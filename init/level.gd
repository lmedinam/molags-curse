extends Spatial

var can_start = false

func _ready():
	$Transition.fade_in()
	$AnimationPlayer.play("reset")

func _input(event):
	if event is InputEventKey and not event.is_action("fullscreen"):
		if can_start:
			$AnimationPlayer.play("start")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "start":
		get_tree().change_scene("res://level/level.tscn")

func _on_start_delay_timeout():
	can_start = true
