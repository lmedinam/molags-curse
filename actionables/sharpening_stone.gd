extends StaticBody

var taked = false

func actuate():
	if not taked and GameManager.player.has_sword:
		set_collision_layer_bit(1, false)
		GameManager.player.offset_ap.play("pickup")
		GameManager.player.stop_player = true
		$PickupDelay.start()
		taked = true

func _on_pickup_delay_timeout():
	GameManager.player.sharpness += 1
	GameManager.player.run_sharpening_sword_anim()
	
	$Model.visible = false
	call_deferred("queue_free")
