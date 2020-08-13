extends Spatial

func update_boss_door(status):
	$BossSectionDoor.is_lock = status

func _on_trap_lever_triggered(status):
	$Fireball.active = status

func _on_shield_door_lever_triggered(status):
	$ShieldDoor.is_lock = status

func _on_shield_door_exit_lever_triggered(status):
	$ShieldDoorExit.is_lock = status
