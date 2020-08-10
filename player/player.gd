extends KinematicBody

const SPEED = 2
const ACCEL = 2
const DEACCEL = 4
const GRAVITY = -9.8 * 3
const BASE_DAMAGE = 6

var camera_angle = 0
var mouse_sensitivity = 1.5
var velocity = Vector3()

onready var actioner = $Offset/Head/Camera/Actioner
onready var hit_area = $Offset/Head/Camera/HitArea
onready var head_at = $Offset/Head/AnimationTree
onready var left_hand_at = $Objects/LeftHand/AnimationTree
onready var right_hand = $Objects/RightHand/AnimationTree
onready var offset_ap = $Offset/AnimationPlayer

var hp = 100.0
var stamina = 100
var gold = 0
var sharpness = 0
var refilling = true
var death = false
var shield_up = false

var head_st: AnimationNodeStateMachinePlayback
var right_hand_st: AnimationNodeStateMachinePlayback
var left_hand_st: AnimationNodeStateMachinePlayback

var stop_player = false
var slow_player = false

func _ready():
	GameManager.player = self
	
	head_st = head_at.get("parameters/playback")
	right_hand_st = right_hand.get("parameters/playback")
	left_hand_st = left_hand_at.get("parameters/playback")
	
	head_st.start("idle")
	right_hand_st.start("idle")
	left_hand_st.start("idle")
	
	var right_hand_ap = $Objects/RightHand/AnimationPlayer
	right_hand_ap.connect("animation_finished", self, "_on_animation_finished")

func _process(delta):
	if velocity.length() < 0.5:
		head_st.travel("idle")
	else:
		head_st.travel("walking")
	
	if actioner.is_colliding():
		var collider = actioner.get_collider()
		GameManager.game_info.show_action_icon(collider.has_method("actuate"))
	else:
		GameManager.game_info.show_action_icon(false)
	
	GameManager.game_info.player_hp(hp)
	GameManager.game_info.player_stamina(stamina)
	
	if stamina <= 0 and shield_up:
		shield_up = false
		left_hand_st.travel("idle")

func _input(event):
	if event is InputEventMouseMotion and not death:
		# Horizontal aim
		$Offset/Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		# Vertical aim
		var change = -event.relative.y * mouse_sensitivity
		var next_angle = change + camera_angle
		if next_angle < 90 and next_angle > -90:
			$Offset/Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
	
	if event.is_action_pressed("action"):
		if actioner.is_colliding():
			var collider = actioner.get_collider()
			if collider.has_method("actuate"):
				collider.actuate()
	
	if event.is_action_pressed("hit") and stamina > 0:
		right_hand_st.travel("attack")
	
	if event.is_action_pressed("shield") and stamina > 0:
		shield_up = true
		left_hand_st.travel("defend")
	
	if event.is_action_released("shield"):
		shield_up = false
		left_hand_st.travel("idle")

func _physics_process(delta):
	var c_basis = $Offset/Head/Camera.global_transform.basis
	var h_basis = $Offset/Head.global_transform.basis
	var o_basis = $Objects.transform.basis
	
	var current_rot = Quat($Objects.transform.basis.orthonormalized())
	var target_rot = Quat(c_basis)
	var smoothrot = current_rot.slerp(target_rot, 0.20)
	
	$Objects.transform.basis = Basis(smoothrot)
	
	var direction = Vector3()
	
	if not stop_player and not death:
		if Input.is_action_pressed("ui_down"):
			direction += h_basis.z
		if Input.is_action_pressed("ui_up"):
			direction -= h_basis.z
		if Input.is_action_pressed("ui_right"):
			direction += c_basis.x
		if Input.is_action_pressed("ui_left"):
			direction -= c_basis.x
	
	direction = direction.normalized()
	velocity.y += GRAVITY * delta
	
	var temp_velocity = velocity
	temp_velocity.y = 0
	
	var target = direction * (SPEED if not slow_player else 1)
	
	var acceleration = DEACCEL
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))

func do_damage():
	var bodies = hit_area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("hit"):
			body.hit(-$Objects.transform.basis.z, BASE_DAMAGE + sharpness + floor(gold / 20))

func got_hit():
	GameManager.game_info.show_ui()
	
	if shield_up and hp > 0:
		use_stamina(20)
	elif hp > 0:
		hp -= 20
		$HurtSound.play()
	
	if hp <= 0 and not death:
		death = true
		$Offset/AnimationPlayer.play("die")
		

func run_pickup_anim():
	stop_player = true
	
	$Offset/AnimationPlayer.play("pickup")
	$PickupItemDelay.start()

func run_sharpening_sword_anim():
	slow_player = true	
	
	right_hand_st.travel("sharpening_sword")
	
	$SharpeningSwordDelay.start()
	$PickupItemDelay.start()

func use_stamina(quantity: int):
	stamina -= quantity
	refilling = false
	$RefillDelay.start()
	GameManager.game_info.show_ui()

func _on_pickup_item_delay_timeout():
	stop_player = false

func _on_sharpening_sword_delay_timeout():
	slow_player = false

func _on_refill_tick_timeout():
	stamina += 2 if (refilling and not shield_up) else 0
	
	if stamina > 100:
		stamina = 100
	else:
		GameManager.game_info.show_ui()

func _on_refill_delay_timeout():
	refilling = true

func _on_shield_up_timer_timeout():
	if shield_up:
		use_stamina(2)
