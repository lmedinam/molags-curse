extends KinematicBody

const KNOCKBACK_SPEED = 30

var knockback = 0
var knockback_dir = Vector3()

var hp = 20
var death = false

var can_attack = true
var attacking = false

func _ready():
	pass

func hit(knockback: Vector3, hp: int):
	if self.knockback <= 0:
		knockback_dir = knockback * 10
		self.hp -= hp
		self.knockback = 0.2
		$Particles.emitting = true
		
		if self.hp <= 0 and not death:
			kill()

func kill():
	death = true
	
	var qt = Timer.new()
	add_child(qt)
	
	qt.connect("timeout", self, "queue_free")
	qt.wait_time = 2.0
	qt.start()

func _physics_process(delta):
	if not death:
		turn_face(GameManager.player, delta)
	
	var direction = Vector3()
	
	direction -= transform.basis.z
	
	if knockback > 0:
		direction += knockback_dir * delta * KNOCKBACK_SPEED
		knockback -= delta
	
	if not death:
		move_and_slide(direction, Vector3(0, 1, 0))

func turn_face(target, delta):
	var current_rotation = Quat(global_transform.basis)
	
	# Let's this function do all the work for us
	look_at(target.global_transform.origin, Vector3.UP)
	var target_rotation = Quat(global_transform.basis)
	
	# Interpolate rotation
	var next_rotation = current_rotation.slerp(target_rotation, delta* 3)
	global_transform.basis = Basis(next_rotation)

func _on_hit_area_body_entered(body):
	if body.has_method("got_hit") and can_attack:
		can_attack = false
		body.got_hit()
