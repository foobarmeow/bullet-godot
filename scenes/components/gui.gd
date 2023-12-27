extends Control

func _unhandled_input(_event):
	if Input.is_action_just_pressed("action_input"):
		print("SPACE")
		SignalBus.level_action.emit()
		return

func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		print("not container wtf")
		return
	var heart = $HeartContainer.get_children().pop_back()
	heart.remove()
		
func _on_display_blood_hell():
	$PentagramContainer.visible = true
