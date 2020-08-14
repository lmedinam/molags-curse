extends KinematicBody

signal killed

const KNOCKBACK_SPEED = 20

var knockback = 0
var knockback_dir = Vector3()

export var hp: int = 20
var death = false

var can_attack = true
var attacking = false
export var fireball: bool

onready var anim_tree = $AnimationTree
var anim_sm: AnimationNodeStateMachinePlayback

var fireball_projectile = preload("res://traps/fireball_projectile.tscn")

export var started: bool = false
export var at_see_player: bool = true

func _ready():
	anim_sm = anim_tree.get("parameters/playback")
	
	if fireball:
		$Mesh/Body/ArmL/Staff.visible = true
		$Mesh/Body/ArmL/Sword.visible = false
	else:
		$Mesh/Body/ArmL/Staff.visible = false
		$Mesh/Body/ArmL/Sword.visible = true
	
	if started:
		anim_sm.start("walking")

func start():
	started = true
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
	
	emit_signal("killed")

func _physics_process(delta):
	if not death:
		turn_face(GameManager.player, delta)
		
		var space_state = get_world().direct_space_state
		var p_position = GameManager.player.global_transform.origin
		var e_position = global_transform.origin
		var r_result = space_state.intersect_ray(e_position, p_position)
		
		if r_result and at_see_player:
			if r_result.collider.has_method("use_stamina") and not started:
				start()
	
	var direction = Vector3()
	
	if not death and can_attack and started:
		direction -= transform.basis.z
	
	if knockback > 0:
		direction += knockback_dir * delta * KNOCKBACK_SPEED
		knockback -= delta
	
	move_and_slide(direction, Vector3(0, 1, 0))

func _process(_delta):
	var bodies
	if fireball:
		bodies = $FarHitArea.get_overlapping_bodies()
	else:
		bodies = $HitArea.get_overlapping_bodies()
	
	for body in bodies:
		if body.has_method("got_hit") and can_attack and not death and started:
			can_attack = false
			anim_sm.travel("attacking")

func turn_face(target, delta):
	if started:
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
	
	if fireball:
		var p_instance = fireball_projectile.instance()
		
		p_instance.direction = global_transform.basis.z
		p_instance.speed = -3
		p_instance.transform.origin = $FiraballSpawn.transform.origin
		
		add_child(p_instance)
	else:
		var bodies = $HitArea.get_overlapping_bodies()
		for body in bodies:
			if body.has_method("got_hit"):
				body.got_hit()

func set_can_attack(value: bool):
	can_attack = true
