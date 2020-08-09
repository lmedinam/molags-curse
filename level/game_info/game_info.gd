extends Control

func _ready():
	GameManager.game_info = self
	$TopContainer.visible = false
	$PlayerHP.visible = false
	$PlayerStamina.visible = false

func player_hp(hp: float):
	$PlayerHP.value = hp
	
func player_stamina(stamina: float):
	$PlayerStamina.value = stamina

func show_action_icon(toggle: bool):
	$TopContainer.visible = toggle

func show_ui():
	$PlayerHP.visible = true
	$PlayerStamina.visible = true
	$HideUITimer.start()

func _on_hide_ui_timer_timeout():
	$PlayerHP.visible = false
	$PlayerStamina.visible = false
