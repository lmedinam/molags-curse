extends StaticBody

var taked = false

func actuate():
	if not taked:
		set_collision_layer_bit(1, false)
		GameManager.player.run_pickup_anim()
		taked = true
		$TakeTimer.start()

func taken():
	$Object.visible = false
	GameManager.player.has_sword = true
	queue_free()

func _on_take_timer_timeout():
	taken()
