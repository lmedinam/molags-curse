extends KinematicBody

export var direction: Vector3
export var speed: float

func _ready():
	$ShootSound.play()

func _physics_process(delta):
	move_and_collide(direction * speed * delta)

func _on_area_body_entered(body):
	direction = Vector3()
	
	$Area.set_collision_layer_bit(0, false)
	$Area.set_collision_mask_bit(0, false)
	$BallParticles.emitting = false
	$Tail.emitting = false
	$DestroyTimer.start()
	$ExplosionParticles.emitting = true
	$AnimationPlayer.play("explode")
	$ExplosionSound.play()
	
	if body.has_method("got_hit"):
		body.got_hit()

func _on_destroy_timer_timeout():
	call_deferred("queue_free")
