extends KinematicBody

signal door_triggered

func actuate():
	emit_signal("door_triggered")
