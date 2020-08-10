extends KinematicBody

const KNOCKBACK_SPEED = 20

var knockback = 0
var knockback_dir = Vector3()

var hp = 20
var death = false

var can_attack = true
var attacking = false

onready var anim_tree = $AnimationTree
var anim_sm: AnimationNodeStateMachinePlayback

func _ready():
	anim_sm = anim_tree.get("parameters/playback")
	anim_sm.start("walking")

func hit(knockback: Vector3, hp: int):
	if self.knockback <= 0:
		knockback_dir = knockback * 10
		self.hp -= hp
		self.knockback = 0.2
		$Particles.emitting = true
		
		if self.hp <= 0 and not death:
			anim_sm.call_deferred("travel", "die")
			kill()

func kill():
	death = true
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	
	# Only map collision
	set_collision_layer_bit(2, true)
	
	var qt = Timer.new()
	add_child(qt)
	
	# qt.connect("timeout", self, "queue_free")
	qt.wait_time = 2.0
	qt.start()

func _physics_process(delta):
	if not death:
		turn_face(GameManager.player, delta)
	
	var direction = Vector3()
	
	if not death and can_attack:
		direction -= transform.basis.z
	
	if knockback > 0:
		direction += knockback_dir * delta * KNOCKBACK_SPEED
		knockback -= delta
	
	move_and_slide(direction, Vector3(0, 1, 0))

func _process(delta):
	print_debug(can_attack)
	var bodies = $HitArea.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("got_hit") and can_attack and not death:
			can_attack = false
			anim_sm.travel("attacking")

func turn_face(target, delta):
	var current_rotation = Quat(global_transform.basis)
	
	# Let's this function do all the work for us
	look_at(target.global_transform.origin, Vector3.UP)
	var target_rotation = Quat(global_transform.basis)
	
	# Interpolate rotation
	var next_rotation = current_rotation.slerp(target_rotation, delta* 3)
	global_transform.basis = Basis(next_rotation)

func _on_hit_area_body_entered(body):
	pass

func attack():
	if not death:
		anim_sm.travel("walking")
	
	var bodies = $HitArea.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("got_hit"):
			body.got_hit()

func set_can_attack(value: bool):
	can_attack = true
