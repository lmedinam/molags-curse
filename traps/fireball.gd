extends Spatial

export var shoot_delay: float
export var start_delay: float
export var speed: float
export var active: bool

var fireball_projectile = preload("res://traps/fireball_projectile.tscn")

func _ready():
	$DelayTimer.wait_time = shoot_delay
	
	if start_delay > 0:
		$StartDelay.wait_time = start_delay
		$StartDelay.start()
	else:
		$DelayTimer.start()

func _on_delay_timer_timeout():
	if active:
		shoot()

func _on_start_delay_timeout():
	$DelayTimer.start()

func shoot():
	var p_instance = fireball_projectile.instance()
	p_instance.direction = global_transform.basis.z
	p_instance.speed = speed
	p_instance.transform.origin = $SpawnPoint.transform.origin
	add_child(p_instance)
