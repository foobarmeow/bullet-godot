extends Control


func _ready():
	SignalBus.player_ready.connect(func():
		$HeartContainer.show()
	)
	SignalBus.dead_title.connect(func():
		$ContinueContainer.show()
		$ContinueContainer/AnimationPlayer.play_backwards("fade_title")
	)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action_input"):
		SignalBus.level_action.emit()
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
