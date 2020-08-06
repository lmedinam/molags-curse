extends StaticBody

func actuate():
	set_collision_layer_bit(1, false)
	$AnimationPlayer.play("open")
