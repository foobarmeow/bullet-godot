extends Node2D

signal display_blood_hell

var first_drank: int = 100
var drinking_at_well = false
var blood_hell_activated = false
var dash_given = false
var checkpoint: int = 0

@export var map_anim: AnimationPlayer

func _ready():
	SignalBus.connect("level_action", _on_level_action)
	SignalBus.connect("start_pressed", _on_start_pressed)
	SignalBus.connect("continue_pressed", _on_continue_pressed)
	# move the player over to the intro
	#var titleArea = $Scenery/TitleArea
	#$Player.position = titleArea.position

	# Pause the player
	$Player.process_mode = Node.PROCESS_MODE_DISABLED

	# Turn him off
	$Player.visible = false

func _on_start_pressed():
	map_anim.play("FadeOut")
	map_anim.animation_finished.connect(func(anim_name):
		match anim_name:
			"FadeOut":
				# Move to the start point
				$Player.position = $Scenery/StartNode.position

				# Fade the scene in
				map_anim.play("FadeIn")
			"FadeIn":
				# Unpause the player
				$Player.process_mode = Node.PROCESS_MODE_INHERIT
				$Player.visible = true
				SignalBus.player_ready.emit()
	)



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



func _unhandled_input(event):
	if event.is_action_pressed("blood_hell"):
		blood_hell_activated = !blood_hell_activated
		display_blood_hell.emit()
		if blood_hell_activated:
			$Scenery/Background/RootModulate/AnimationPlayer.play("BloodLoop")
		else:
			$Scenery/Background/RootModulate/AnimationPlayer.play("RESET")


func _on_angel_of_dash_area_area_entered(_area):
	if dash_given:
		return
	SignalBus.display_dialog.emit("angel_of_dash")
	SignalBus.dialog_finished.connect(func():
		# Give the boi the dash
		$Player.can_dash = true
		dash_given = true
	)


func _on_south_entrance_area_area_entered(_area):
	if !$Player.can_dash:
		SignalBus.display_dialog.emit("player_south_entrance_not_ready")
		return
	if !quest_given:
		SignalBus.display_dialog.emit("head_south")
		quest_given = true


var fridge_bridge_occurred: bool = false
func _on_fridge_bridge_area_area_entered(_area):
	if fridge_bridge_occurred: 
		return
	fridge_bridge_occurred = true
	
	# Pause the player
	$Player.process_mode = Node.PROCESS_MODE_DISABLED

	$Scenery/Bridge/AnimationPlayer.animation_finished.connect(_on_bridge_fall_finished)
	$Scenery/Bridge/AnimationPlayer.play("bridge_fall_animation")


func _on_bridge_fall_finished(_animation_name):
	SignalBus.display_dialog.emit("bridge_collapse")
	$Scenery/Bridge.queue_free()

	# Unpause the player
	$Player.process_mode = Node.PROCESS_MODE_INHERIT


var quest_given: bool = false
func _on_return_area_area_entered(_area):
	if !$Player.can_dash:
		return
	SignalBus.display_dialog.emit("head_south")
	quest_given = true


func _on_intro_area_area_exited(_area):
	SignalBus.display_dialog.emit("intro")

func _on_player_dead():
	map_anim.play("FadeOut")
	SignalBus.dead_title.emit()
		

func _on_continue_pressed():
	match checkpoint:
		0:
			$Player.position = $Scenery/StartNode.position
		1:
			$Player.position = $Scenery/Checkpoint1.position
		2: 
			$Player.position = $Scenery.Checkpoint2.position	
	map_anim.play("FadeIn")
