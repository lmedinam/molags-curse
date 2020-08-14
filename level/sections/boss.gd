extends Spatial

var molag_stage = 0
var skeleton = preload("res://enemies/skeleton.tscn")

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
	if body.has_method("use_stamina"):
		$MainBossDoor._on_container_door_triggered()
		$MainBossDoor.is_lock = true
		
		$PlayerTransition.visible = true
		
		GameManager.player.stop_player = true
		$PlayerTransition.fade_out()

func end_animation():
	$CameraTransition.visible = true
	$CameraTransition.fade_out()

func _on_player_transition_fade_out():
	$PlayerTransition.fade_in()
	$AnimationPlayer.play("molag_camera")

func _on_camera_transition_fade_out():
	GameManager.player.make_player_current_camera()
	GameManager.player.stop_player = false
	$Molag.start()
	
	$CameraTransition.fade_in()

func _on_molag_death():
	if molag_stage >= 2:
		$PlayerWins.start()
	else:
		molag_stage += 1
		$Spawns/SkeletonsDelay.start()
		skeleton_spawn_emitting(true)

func spawn_skeleton(var node: Spatial):
	var skeleton_i = skeleton.instance()
	skeleton_i.hp = 24
	skeleton_i.connect("killed", self, "_on_kill_skeleton")
	node.add_child(skeleton_i)

func spawn_skeletons():
	spawn_skeleton($Spawns/SkeletonSpawnerL)
	spawn_skeleton($Spawns/SkeletonSpawnerR)

func skeleton_spawn_emitting(state: bool):
	$Spawns/SkeletonSpawnerL/Particles.emitting = state
	$Spawns/SkeletonSpawnerR/Particles.emitting = state

func some_skeleton_alive():
	var deaths = []
	
	for child in $Spawns/SkeletonSpawnerL.get_children():
		if child.has_method("kill"):
			if not child.death:
				return true
	
	for child in $Spawns/SkeletonSpawnerR.get_children():
		if child.has_method("kill"):
			if not child.death:
				return true
	
	return false

func respawn_molag():
	var molag = skeleton.instance()
	molag.connect("killed", self, "_on_molag_death")
	molag.hp = 30
	molag.fireball = true
	$Spawns/MolagSpawner.add_child(molag)

func _on_kill_skeleton():
	if not some_skeleton_alive():
		$Spawns/MolagSpawner/Particles.emitting = true
		$Spawns/MolagDelay.start()

func _on_skeletons_delay_timeout():
	spawn_skeletons()
	skeleton_spawn_emitting(false)

func _on_molag_delay_timeout():
	respawn_molag()
	$Spawns/MolagSpawner/Particles.emitting = false

func _on_player_wins_timeout():
	GameManager.player.wins()
