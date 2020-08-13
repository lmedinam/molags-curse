extends Control

func _ready():
	$Transition.fade_in()
	$Timer.start()

func _on_timer_timeout():
	$Transition.fade_out()

func _on_transition_fade_out():
	get_tree().change_scene("res://init/level_map.tscn")
