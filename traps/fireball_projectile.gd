extends KinematicBody

export var direction: Vector3
export var speed: float

func _physics_process(delta):
	move_and_collide(direction * speed * delta)

func _on_area_body_entered(body):
	direction = Vector3()
	$BallParticles.emitting = false
	$Tail.emitting = false
	$DestroyTimer.start()
	$ExplosionParticles.emitting = true
	$AnimationPlayer.play("explode")

func _on_destroy_timer_timeout():
	call_deferred("queue_free")
