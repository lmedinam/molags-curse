extends Node

onready var viewport = get_viewport()
var player: KinematicBody

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
