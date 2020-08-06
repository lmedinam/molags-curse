extends StaticBody

var taked = false

func actuate():
	if not taked:
		GameManager.player.run_pickup_anim()
		$AnimationPlayer.play("pickup")
		taked = true

func taken():
	set_collision_mask_bit(1, false)
	$AudioStreamPlayer.playing = true
	$Coin.visible = false
	GameManager.player.gold += 20

func _on_audio_finished():
	call_deferred("queue_free")
