extends Spatial

func _input(event):
	if event.is_action_pressed("take_screenshot"):
		var capture = get_viewport().get_texture().get_data().flip_y()
		capture.save_png("user://screenshot.png")
