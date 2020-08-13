extends Spatial

func _on_library_open_boss_section(is_lock):
	$Sections/DungeonKitchen.update_boss_door(is_lock)
