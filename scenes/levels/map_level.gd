extends Node2D

signal display_blood_hell

var first_drank: int = 100
var drinking_at_well = false
var blood_hell_activated = false
var dash_given = false
var checkpoint: int = 0
var dead: bool = false
var first_start: bool = true

@onready var checkpoint_position: Vector2 = $Scenery/StartNode.position

# Narrative event booleans
var intro_given: bool = false
var fridge_bridge_occurred: bool = false
var quest_given: bool = false

# debug shit
var loaded: bool = false

@export var map_anim: AnimationPlayer

func _ready():
	SignalBus.connect("level_action", _on_level_action)
	SignalBus.connect("start_pressed", _on_start_pressed)
	SignalBus.connect("continue_pressed", _on_continue_pressed)
	SignalBus.connect("enemy_dead", _on_enemy_dead)
	SignalBus.connect("fun_part", _load.bind(666))

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
				if first_start:
					$Player.position = checkpoint_position
					first_start = false

				if !dead:
					# Fade the scene in
					map_anim.play("FadeIn")
			"FadeIn":
				# Unpause the player
				$Player.process_mode = Node.PROCESS_MODE_INHERIT
				$Player.visible = true
				$Player.continue_game()
				SignalBus.player_ready.emit()
				if !loaded:
					_load(669)
					loaded = true
	) 



func _on_level_action():
	SignalBus.display_dialog.emit("advance_text")


func _unhandled_input(event):
	if event.is_action_pressed("debug_kill"):
		$Player.take_damage(30, null)
	if event.is_action_pressed("blood_hell"):
		_display_blood_hell()

func _display_blood_hell():
	blood_hell_activated = !blood_hell_activated
	display_blood_hell.emit()
	if blood_hell_activated:
		$Scenery/Background/SceneryModulate/AnimationPlayer.play("BloodLoop")
	else:
		$Scenery/Background/SceneryModulate/AnimationPlayer.play("RESET")



func _on_angel_of_dash_area_area_entered(_area):
	if dash_given:
		return
	SignalBus.display_dialog.emit("angel_of_dash")
	SignalBus.dialog_finished.connect(func():
		# Give the boi the dash
		$Player.can_dash = true
		dash_given = true
	, CONNECT_ONE_SHOT)
	set_checkpoint(2)


func _on_south_entrance_area_area_entered(_area):
	if !$Player.can_dash:
		SignalBus.display_dialog.emit("player_south_entrance_not_ready")
		return
	if !quest_given:
		SignalBus.display_dialog.emit("head_south")
		quest_given = true
		set_checkpoint(3)


func _on_fridge_bridge_area_area_entered(_area):
	if fridge_bridge_occurred: 
		return
	fridge_bridge_occurred = true
	
	# Pause the player
	$Player.process_mode = Node.PROCESS_MODE_DISABLED

	$Scenery/Bridge/AnimationPlayer.animation_finished.connect(_on_bridge_fall_finished)
	$Scenery/Bridge/AnimationPlayer.play("bridge_fall_animation")
	set_checkpoint(1)


func _on_bridge_fall_finished(_animation_name):
	SignalBus.display_dialog.emit("bridge_collapse")
	$Scenery/Bridge.queue_free()

	# Unpause the player
	$Player.process_mode = Node.PROCESS_MODE_INHERIT
	SignalBus.change_music.emit(3)


func _on_return_area_area_entered(_area):
	if !$Player.can_dash || quest_given:
		return
	SignalBus.display_dialog.emit("head_south")
	quest_given = true
	set_checkpoint(3)
	SignalBus.change_music.emit(4)


func _on_intro_area_area_exited(_area):
	if intro_given:
		return
	SignalBus.display_dialog.emit("intro")
	intro_given = true
	SignalBus.change_music.emit(2)

func _on_player_dead():
	dead = true
	map_anim.play("FadeOut")
	SignalBus.dead_title.emit()

func _on_continue_pressed():
	# clear up all the splatter
	get_tree().call_group("splatter", "queue_free")
	$Player.position = checkpoint_position
	map_anim.play("FadeIn")
	dead = false

func _on_angel_of_death_area_area_entered(_area):
	if $Player.has_weapon:
		return
	SignalBus.display_dialog.emit("angel_of_death")
	SignalBus.dialog_finished.connect(func():
		_display_blood_hell()
		SignalBus.weapon_get.emit()
		# Give the boi the weapon
		$Player.has_weapon = true
		set_checkpoint(4)
		SignalBus.gui_done.connect(func():
			_display_blood_hell()
			SignalBus.change_music.emit(5)
		, CONNECT_ONE_SHOT)
	, CONNECT_ONE_SHOT)

func _on_enemy_dead():
	var enemies = $CharacterLayer/Enemies.get_children()
	var undead = 0
	for e in enemies:
		if !e.is_dead:
			undead+=1

	if undead == 0:
		end_game()

func end_game():
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	SignalBus.dialog_finished.connect(func(): 
		SignalBus.game_end.emit()
	, CONNECT_ONE_SHOT)
	SignalBus.display_dialog.emit("fin")

func set_checkpoint(c: int):
	checkpoint = c
	var container = $Scenery/Checkpoints
	var cp = container.get_node("Checkpoint%s" % c)
	checkpoint_position = cp.position

func _load(step: int):
	match step:
		1:
			$Player.position = $Scenery/Checkpoints/Checkpoint1.position
			set_checkpoint(1)
		2:
			$Player.position = $Scenery/Checkpoints/Checkpoint2.position	
			$Player.can_dash = true
			set_checkpoint(2)
		3: 
			$Player.position = $Scenery/Checkpoints/Checkpoint3.position	
			$Player.can_dash = true
			quest_given = true
			set_checkpoint(3)
		4: 
			$Player.position = $Scenery/Checkpoints/Checkpoint3.position	
			$Player.can_dash = true
			$Player.has_weapon = true
			quest_given = true
			set_checkpoint(4)
		69:
			$Player.position = $Scenery/DebugPosition.position	
			$Player.can_dash = true
			quest_given = true
			set_checkpoint(4)
		666:
			SignalBus.change_music.emit(5)
			$Player.process_mode = Node.PROCESS_MODE_INHERIT
			$Player.position = $Scenery/DebugPosition.position	
			$Player.can_dash = true
			quest_given = true
			$Player.has_weapon = true
			set_checkpoint(4)
		669:
			SignalBus.change_music.emit(5)
			$Player.position = $Scenery/DebugPosition.position	
			$Player.can_dash = true
			quest_given = true
			$Player.has_weapon = true
			set_checkpoint(4)
			end_game()
	intro_given = true
	fridge_bridge_occurred = true
	get_tree().call_group("splatter", "queue_free")


