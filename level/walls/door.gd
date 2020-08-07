extends Spatial

var open = false
export var is_lock = false

func _ready():
	$AnimationPlayer.play("closed")

func _on_container_door_triggered():
	if not $AnimationPlayer.is_playing() and not is_lock:
		var anim_name = "close" if open else "open"
		
		open = not open
		$AnimationPlayer.play(anim_name)
		
