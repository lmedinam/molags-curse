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
		
		GameManager.player.stop_player = true
		$PlayerTransition.fade_out()

func end_animation():
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
	if molag_stage >= 3:
		pass
	else:
		molag_stage += 1
		spawn_skeletons()

func spawn_skeleton(var node: Spatial):
	var skeleton_i = skeleton.instance()
	skeleton_i.connect("death", self, "_on_kill_skeleton")
	node.add_child(skeleton_i)

func spawn_skeletons():
	spawn_skeleton($Spawns/SkeletonSpawnerL)
	spawn_skeleton($Spawns/SkeletonSpawnerR)

func some_skeleton_alive():
	for child in $Spawns/SkeletonSpawnerL.get_children():
		if child.has_method("kill"):
			if not child.death:
				return true
	
	for child in $Spawns/SkeletonSpawnerL.get_children():
		if child.has_method("kill"):
			if not child.death:
				return true
	
	return false

func respawn_molag():
	var molag = skeleton.instance()
	molag.connect("death", self, "_on_molag_death")
	molag.fireball = true
	$Spawns/MolagSpawner.add_child(molag)

func _on_kill_skeleton():
	if not some_skeleton_alive():
		respawn_molag()
