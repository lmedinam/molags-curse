extends KinematicBody

const KNOCKBACK_SPEED = 30

var knockback = 0
var knockback_dir = Vector3()

func hit(knockback: Vector3):
	if self.knockback <= 0:
		knockback_dir = knockback * 10
		self.knockback = 0.2

func _physics_process(delta):
	turn_face(GameManager.player, delta)
	
	var direction = Vector3()
	direction -= transform.basis.z
	
	if knockback > 0:
		direction += knockback_dir * delta * KNOCKBACK_SPEED
		knockback -= delta
	
	move_and_slide(direction, Vector3(0, 1, 0))

func turn_face(target, delta):
	var current_rotation = Quat(global_transform.basis)
	
	# Let's this function do all the work for us
	look_at(target.global_transform.origin, Vector3.UP)
	var target_rotation = Quat(global_transform.basis)
	
	# Interpolate rotation
	var next_rotation = current_rotation.slerp(target_rotation, delta* 3)
	global_transform.basis = Basis(next_rotation)
