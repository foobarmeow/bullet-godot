extends Control

func _ready():
	SignalBus.player_ready.connect(func():
		$HeartContainer.show()
	)

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action_input"):
		SignalBus.level_action.emit()
		return

func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		return
	var heart = $HeartContainer.get_children().pop_back()
	heart.remove()
		
func _on_display_blood_hell():
	$PentagramContainer.visible = !$PentagramContainer.visible


func _on_start_button_pressed():
	$TitleContainer/AnimationPlayer.play("fade_title")
	SignalBus.start_pressed.emit()
