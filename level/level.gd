extends Spatial

func _ready():
	$Lever.connect("fired", self, "lever_action")
	

func lever_action(status: bool): 
	print_debug("Lever triggered: " + str(status))
