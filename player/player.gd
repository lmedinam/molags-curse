extends KinematicBody

const SPEED = 6
const ACCEL = 2
const DEACCEL = 6
const GRAVITY = -9.8 * 3

var camera_angle = 0
var mouse_sensitivity = 1.5
var velocity = Vector3()

onready var actioner = $Head/Camera/Actioner

func _input(event):
	if event is InputEventMouseMotion:
		# Horizontal aim
		$Head.rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		
		# Vertical aim
		var change = -event.relative.y * mouse_sensitivity
		var next_angle = change + camera_angle
		if next_angle < 90 and next_angle > -90:
			$Head/Camera.rotate_x(deg2rad(change))
			camera_angle += change
	
	if event.is_action_pressed("action"):
		if actioner.is_colliding():
			var collider = actioner.get_collider()
			if collider.has_method("actuate"):
				collider.actuate()

func _physics_process(delta):
	var c_basis = $Head/Camera.global_transform.basis
	var h_basis = $Head.global_transform.basis
	var o_basis = $Objects.transform.basis
	
	var current_rot = Quat($Objects.transform.basis)
	var target_rot = Quat(c_basis)
	var smoothrot = current_rot.slerp(target_rot, 0.20)
	
	$Objects.transform.basis = Basis(smoothrot)
	
	var direction = Vector3()
	
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
	
	var target = direction * SPEED
	
	var acceleration = DEACCEL
	if direction.dot(temp_velocity) > 0:
		acceleration = ACCEL
	
	temp_velocity = temp_velocity.linear_interpolate(target, acceleration * delta)
	
	velocity.x = temp_velocity.x
	velocity.z = temp_velocity.z
	
	velocity = move_and_slide(velocity, Vector3(0, 1, 0))
	
