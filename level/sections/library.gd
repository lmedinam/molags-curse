extends Spatial

signal open_boss_section(is_lock)

func _on_forbiden_library_lever_triggered(status):
	$Doors/DarkLibraryDoor2.is_lock = status

func _on_forbiden_library_lever_2_triggered(status):
	$Doors/DarkLibraryDoor.is_lock = status

func _on_cross_lever_triggered(status):
	$Doors/DoorCross.is_lock = status

func _on_trap_leverL_triggered(status):
	$FireballL.active = status

func _on_trapleverR_triggered(status):
	$FireballR.active = status

func _on_boss_lever_triggered(status):
	emit_signal("open_boss_section", status)
