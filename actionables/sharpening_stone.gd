extends StaticBody

var taked = false

func actuate():
	if not taked:
		set_collision_layer_bit(1, false)
		GameManager.player.offset_ap.play("pickup")
		$PickupDelay.start()
		taked = true

func _on_pickup_delay_timeout():
	$Model.visible = false
	GameManager.player.run_sharpening_sword_anim()
