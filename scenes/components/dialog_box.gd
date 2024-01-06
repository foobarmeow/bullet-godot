extends Node2D

enum BoxType {ACTION, DIALOG}

@export var type: BoxType = BoxType.DIALOG

var dialog_dict = {
	"action_drink": "Drink!\n(space)",
	"player_south_entrance_not_ready": [
		"You're not ready my guy.",
		"The Bad Guys™ are down there.",
		"Go get my frickin La Croix, boy."
	],
	"intro": [
		"My boy...",
		"The time has come...",
		"I need you, the village needs you...",
		"To get me a La Croix.",
		"From the fridge up north yonder there...",
		"Over the bridge...",
		"Pomplamoose...",
		"Now get!"
	],
	"bridge_collapse": [
		"Yikes, the bridge collapsed...",
		"Oh well. Go see the ANGEL OF DASH.",
		"Then you can DASH over the pit.",
		"WITH my La Croix.",
		"And watch out for rocks!",
	],
	"drink_success": [
		"Nice you drank, that's sick.",	
	 	"Now get back to me.",
	],
	"angel_of_dash": [
		"What's up I'm the Angel of DASH.",
		"I hand out the power to DASH",
		"Get at it with SHIFT",
		"Love you *kiss*",
		"Also no idea where the La Croix is."
	],
	"head_south": [
		"I see you have no La Croix...",
		"I heard the Bad Guys™ talking smack,",
		"sayin they took the last two La Croix's",
		"and headed down south with 'em.",
		"Go fetch-itize my La Croix boy,",
		"and be careful the Bad Guys™",
		"don't murkilate you."
	],
	"angel_of_death": [
		"Hey what's up I'm the Angel of Death",
		"These Bad Guys™ have the La Croix",
		"Take it from them.",
		"Use this."
	],
	"fin": [
		"You've killed 'em all.",
		"The Bad Guys™ are dead",
		"and still no La Croix.",
		"Maybe the real La Croix",
		"was just the shotgun blood..."
	]
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
	SignalBus.dialog_finished.emit()
	
func _on_hide_dialog():
	if is_visible:
		$AnimationPlayer.play_backwards("show")
		is_visible = false
		
func _on_input_action():
	$AnimationPlayer.play("shake")
	

