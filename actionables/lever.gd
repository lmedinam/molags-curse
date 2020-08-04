extends Spatial

signal fired

var status = false

func actuate():
	status = !status
	emit_signal("fired", status)
