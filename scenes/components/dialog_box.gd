extends Control

enum BoxType {ACTION, DIALOG}

@export var type: BoxType = BoxType.DIALOG

var dialog_dict = {
	"action_drink": "Drink!\n(space)"
}

func _ready():
	match type:
		BoxType.DIALOG:
			SignalBus.connect("display_dialog", _on_display_dialog)
		BoxType.ACTION:
			SignalBus.connect("display_action", _on_display_dialog)
	SignalBus.connect("hide_dialog", _on_hide_dialog)

func _on_display_dialog(text_key: String):
	$Label.text = dialog_dict[text_key]
	show()
	
func _on_hide_dialog():
	hide()

