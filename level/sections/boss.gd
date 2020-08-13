extends Spatial

func _on_trap_lever_triggered(status):
	$TrapZone1/Fireball.active = status
	$TrapZone1/Fireball2.active = status
	$TrapZone1/Fireball3.active = status

func _on_trap_lever_2_triggered(status):
	$TrapZone1/FireTrap.turn_on = status
	$TrapZone1/FireTrap2.turn_on = status
	$TrapZone1/FireTrap3.turn_on = status

func _on_trap_lever_3_triggered(status):
	$TrapZone3/FireTrap4.turn_on = status
	$TrapZone3/FireTrap5.turn_on = status

func _on_boss_gate_lever_2_triggered(status):
	$BossDoor1.is_lock = status

func _on_boss_gate_lever_triggered(status):
	$BossDoor2.is_lock = status

func _on_boss_trigger_body_entered(body):
	$MainBossDoor._on_container_door_triggered()
	$MainBossDoor.is_lock = true
