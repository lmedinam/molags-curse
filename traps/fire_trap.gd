extends Spatial

func _on_damage_tick_timeout():
	var bodies = $Area.get_overlapping_bodies()
	for body in bodies:
		if body.has_method("got_hit"):
			body.got_hit()
