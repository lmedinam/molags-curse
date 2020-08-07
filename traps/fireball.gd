extends Spatial

export var shoot_delay: float
export var direction: Vector3
export var speed: float

var fireball_projectile = preload("res://traps/fireball_projectile.tscn")

func _ready():
	$DelayTimer.wait_time = shoot_delay
	$DelayTimer.start()

func _on_delay_timer_timeout():
	shoot()
	
func shoot():
	var p_instance = fireball_projectile.instance()
	p_instance.direction = global_transform.basis.z
	p_instance.speed = speed
	p_instance.transform.origin = $SpawnPoint.transform.origin
	add_child(p_instance)
