extends Control

var paused: bool = false


func _ready():
	SignalBus.player_ready.connect(func():
		$HeartContainer.show()
	)
	SignalBus.dead_title.connect(func():
		$ContinueContainer.show()
		$ContinueContainer/AnimationPlayer.play_backwards("fade_title")
	)
	SignalBus.weapon_get.connect(func():
		$WeaponGetContainer.show()
		$WeaponGetContainer/WeaponContainer/AnimationPlayer.play("weapon_get")
		$WeaponGetContainer/WeaponContainer/AnimationPlayer.animation_finished.connect(func(_a):
			await get_tree().create_timer(.5).timeout
			$WeaponGetContainer/WeaponContainer/AnimationPlayer.play_backwards("weapon_get")
			$WeaponGetContainer/WeaponContainer/AnimationPlayer.animation_finished.connect(func(_a):
				SignalBus.gui_done.emit()
			, CONNECT_ONE_SHOT)
		, CONNECT_ONE_SHOT)
	)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action_input"):
		SignalBus.level_action.emit()
		return
	if Input.is_action_just_pressed("pause"):
		if paused:
			paused = false
			get_tree().paused = false
			$PauseContainer.hide()
		else:
			paused = true
			get_tree().paused = true
			$PauseContainer.show()
		return

func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		return

	var hearts = $HeartContainer.get_children()
	for i in hearts.size():
		var h = hearts[-i-1]
		if h.visible:
			h.hide()
			return
		
func _on_display_blood_hell():
	$PentagramContainer.visible = !$PentagramContainer.visible


func _on_start_button_pressed():
	$TitleContainer/AnimationPlayer.play("fade_title")
	SignalBus.start_pressed.emit()

func _on_continue_button_pressed():
	$ContinueContainer/AnimationPlayer.play("fade_title")
	SignalBus.continue_pressed.emit()

	for h in $HeartContainer.get_children():
		h.show()
