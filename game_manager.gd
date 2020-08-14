extends Node

onready var viewport = get_viewport()
var player: KinematicBody
var game_info

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_viewport_size()
	viewport.connect("size_changed", self, "set_viewport_size")

func set_viewport_size():
	viewport.size = Vector2(64, 64)

func _process(_delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	
	if (Input.is_action_just_pressed("fullscreen")):
		OS.window_fullscreen = !OS.window_fullscreen

func _input(event):
	if event.is_action_pressed("take_screenshot"):
		var screenshots = Directory.new()
		screenshots.open("user://")
		screenshots.make_dir("screenshots")
		
		var dir = Directory.new()
		var file_count = 0
		
		dir.open("user://screenshots")
		dir.list_dir_begin()
		
		while true:
			var file = dir.get_next()
			
			if file == "":
				break
			elif not file.begins_with("."):
				file_count += 1
		
		dir.list_dir_end()
		
		if event.is_action_pressed("take_screenshot"):
			var capture = get_viewport().get_texture().get_data()
			capture.flip_y()
			capture.save_png("user://screenshots/screenshot_"+str(file_count)+".png")
