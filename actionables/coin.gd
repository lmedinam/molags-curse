extends StaticBody

func _ready():
	pass # Replace with function body.

func actuate():
	if not $Audio.playing:
		$Audio.playing = true

func _on_audio_finished():
	GameManager.player.gold += 20
	call_deferred("queue_free")
