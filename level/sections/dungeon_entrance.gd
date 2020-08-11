extends Spatial

func _on_lever_triggered(status):
	$SecretDoor.is_lock = status
