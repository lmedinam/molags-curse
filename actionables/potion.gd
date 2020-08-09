extends StaticBody

var taked = false

func actuate():
	if not taked:
		set_collision_layer_bit(1, false)
		GameManager.player.run_pickup_anim()
		$Timer.start()
		taked = true

func _on_audio_finished():
	call_deferred("queue_free")

func _on_timer_timeout():
	$Object.visible = false
	$AudioStreamPlayer3D.play()
	GameManager.player.hp += 25
