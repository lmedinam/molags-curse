extends Spatial

export var start_delay: float
export var interval: float
export var active: bool
export var turn_on: bool

func _ready():
	if start_delay > 0:
		$StartTimer.wait_time = start_delay
		$StartTimer.start()
	else:
		_on_start_timer_timeout()

func _process(_delta):
	$BallParticles.emitting = active and turn_on

func _on_damage_tick_timeout():
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("got_hit") and active and turn_on:
			body.got_hit()

func _on_start_timer_timeout():
	if interval > 0:
		$IntervalTimer.wait_time = interval
		$IntervalTimer.start()
	
	active = true

func _on_interval_timer_timeout():
	active = !active
