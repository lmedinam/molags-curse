tool
extends Spatial
signal triggered(status)

export var closed = true

var _last_editor_anim
var status

func _ready():
	status = closed
	emit_signal("triggered", status)
	$AnimationPlayer.play("turn_off" if closed else "turn_on")

func _process(delta):
	if Engine.editor_hint:
		var animation = "turn_off" if closed else "turn_on"
		var curr_anim = $AnimationPlayer.current_animation
		
		if curr_anim != "":
			_last_editor_anim = $AnimationPlayer.current_animation
		
		if _last_editor_anim != animation:
			$AnimationPlayer.play(animation)

func actuate():
	if not $AnimationPlayer.is_playing():
		status = !status
		$AnimationPlayer.play("turn_off" if status else "turn_on")
		emit_signal("triggered", status)
