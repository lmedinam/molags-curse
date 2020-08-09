extends Control

func _ready():
	GameManager.game_info = self
	$TopContainer.visible = false

func player_hp(hp: float):
	$PlayerHP.value = hp
	
func player_stamina(stamina: float):
	$PlayerStamina.value = stamina

func show_action_icon(toggle: bool):
	$TopContainer.visible = toggle
