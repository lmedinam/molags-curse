extends Spatial

func _on_section_lever_triggered(status: bool):
	$Doors/SectionDoor.is_lock = status

func _on_prison_lever_r_triggered(status):
	$Doors/Door.is_lock = status
	$Doors/Door2.is_lock = status
	$Doors/Door3.is_lock = status

func _on_prison_lever_l_triggered(status):
	$Doors/Door4.is_lock = status
	$Doors/Door5.is_lock = status
	$Doors/Door6.is_lock = status
