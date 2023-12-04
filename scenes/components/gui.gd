extends Control


func _on_damage_manager_health_updated(_health: int, _init_health: int):
	if !$HeartContainer:
		print("not container wtf")
		return
	var heart = $HeartContainer.get_children().pop_back()
	heart.remove()
		


func _on_well_area_area_entered(_area):
	# Show drink....stuff
	if done_drinking:
		return
	#$AnimationPlayer.play("drink_visibility")
	SignalBus.display_action.emit("action_drink")

func _on_well_area_area_exited(_area):
	if done_drinking:
		return
	SignalBus.hide_dialog.emit()
	#$AnimationPlayer.play_backwards("drink_visibility")
	#$AnimationPlayer.queue("RESET")

func _on_player_drink():
	if done_drinking:
		return
	$AnimationPlayer.queue("shake_the_drink_text")

var done_drinking: bool = false
func _on_map_level_done_drinking():
	if done_drinking:
		return
	done_drinking = true
	
	$AnimationPlayer.queue("drink_visibility")
	$AnimationPlayer.queue("drank_visibility")
	$AnimationPlayer.queue("return_visibiilty")

func show_dialog(dialog: String):
	$DialogBox.show_dialog(dialog)
	
func hide_dialog():
	$DialogBox.hide()
