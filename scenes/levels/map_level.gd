extends Node2D

signal display_blood_hell

var first_drank: int = 100
var drinking_at_well = false


func _ready():
	SignalBus.connect("level_action", _on_level_action)

func _on_level_action():
	if drinking_at_well:
		if first_drank > 0:
			first_drank -= 50
			SignalBus.input_action.emit()

			if first_drank <= 0:
				drinking_at_well = false
				SignalBus.hide_action.emit()
				SignalBus.display_dialog.emit("drink_success")
				return 
	SignalBus.display_dialog.emit("advance_text")


func _on_well_area_area_entered(_area):
	print(first_drank)
	if first_drank > 0:
		drinking_at_well = true
		SignalBus.display_action.emit("action_drink")

func _on_well_area_area_exited(_area):
	if drinking_at_well:
		SignalBus.hide_action.emit()


var intro = true
func _on_begin_area_area_entered(_area):
	if !intro:
		return
	SignalBus.display_dialog.emit("intro")		
	intro = false


func _unhandled_input(event):
	if event.is_action_pressed("blood_hell"):
		display_blood_hell.emit()
		$Scenery/CanvasLayer/RootModulate/AnimationPlayer.play("BloodLoop")
