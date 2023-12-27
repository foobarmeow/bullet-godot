extends Node2D

enum BoxType {ACTION, DIALOG}

@export var type: BoxType = BoxType.DIALOG

var dialog_dict = {
	"action_drink": "Drink!\n(space)",
	"intro": [
		"My boy...it's time to drink.",
		"From the well...",
		"Go find it, get that drank son..."
	],
	"drink_success": [
		"Nice you drank, that's sick.",	
	 	"Now get back to me.",
	],
}

var is_visible = false
var in_progress = false
var selected_text = []

func _ready():
	match type:
		BoxType.DIALOG:
			SignalBus.connect("display_dialog", _on_display_dialog)
			SignalBus.connect("hide_dialog", _on_hide_dialog)
		BoxType.ACTION:
			SignalBus.connect("display_action", _on_display_action)
			SignalBus.connect("hide_action", _on_hide_dialog)
			SignalBus.connect("input_action", _on_input_action)


func _on_display_action(text_key: String):
	if !is_visible:
		$Label.text = dialog_dict[text_key]
		$AnimationPlayer.play("show")
		is_visible = true


func _on_display_dialog(text_key: String):
	if in_progress:
		next_line()
	elif text_key != "advance_text":
		get_tree().paused = true
		in_progress = true
		selected_text = dialog_dict[text_key].duplicate()
		$AnimationPlayer.play("show")
		is_visible = true
		$Label.text = selected_text.pop_front()

func next_line():
	if selected_text.size() > 0:
		$Label.text = selected_text.pop_front()
	else:
		finish()

func finish():
	$AnimationPlayer.play_backwards("show")
	$Label.text = ""
	in_progress = false
	get_tree().paused = false
	
func _on_hide_dialog():
	if is_visible:
		$AnimationPlayer.play_backwards("show")
		is_visible = false
		
func _on_input_action():
	print("PLAYING SHAKE")
	$AnimationPlayer.play("shake")
	

