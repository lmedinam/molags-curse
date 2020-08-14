tool
extends Spatial

var open = false

export var initial_open = false
export var is_lock = false
export var is_iron = false

func _ready():
	$AnimationPlayer.play("opened" if initial_open else "closed")

func _process(delta):
	if is_iron:
		$Offset/Container/WoodDoor.visible = false
		$Offset/Container/IronDoor.visible = true
	else:
		$Offset/Container/WoodDoor.visible = true
		$Offset/Container/IronDoor.visible = false

func _on_container_door_triggered():
	if not $AnimationPlayer.is_playing():
		if is_lock:
			$DoorIsClosed.play()
		else:
			var anim_name = "close" if open else "open"
			
			open = not open
			$AnimationPlayer.play(anim_name)
		
