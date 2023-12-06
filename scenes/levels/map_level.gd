extends Node2D

signal done_drinking

@export var lit_material: CanvasItemMaterial
@export var line_manager: Node2D

var paused: bool

var first_drank: int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	start_movers(get_children())
#	debug_state()
	pass
	
func debug_state():
	if $DebugSpot != null:
		$Player.position = $DebugSpot.position

					
func start_movers(nodes: Array[Node]):
	for n in nodes:
		if n.get_child_count() > 0:
			start_movers(n.get_children())
		if n is Mover:
			n.begin()
			n.dead.connect(_on_mover_dead)

func _on_mover_dead():
	var c = $Enemies.get_children()
	for i in len(c):
		var e = c[i]
		if e.get_node("DamageManager")._health > 0:
			e.show()
			e.process_mode = PROCESS_MODE_INHERIT
			return
	done()

var dun
var dead
func done():
	$Player/Camera2D/GUI/Win.show()
	$Player/Camera2D/GUI.show()
	dun = true

func _on_button_pressed():
	if dun || dead:
		dun = false
		dead = false
		get_tree().reload_current_scene()
		_on_button_pressed()
	$Player/Camera2D/GUI/Welcome.hide()
	$Player/Camera2D/GUI/Win.hide()
	$Player/Camera2D/GUI/Lose.hide()
	$Player/Camera2D/GUI.hide()
	$Enemies.show()
	$Enemies.process_mode = Node.PROCESS_MODE_INHERIT
	start_movers(get_children())

func _on_player_died():
	$Player/Camera2D/GUI/Lose.show()
	$Player/Camera2D/GUI.show()
	dead = true


var drinking_at_well = false
func _on_action_input():
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
	if first_drank > 0:
		drinking_at_well = true
		SignalBus.display_action.emit("action_drink")

func _on_well_area_area_exited(_area):
	if drinking_at_well:
		SignalBus.hide_action.emit()


var intro = false
func _on_begin_area_area_entered(_area):
	if !intro:
		return
	SignalBus.display_dialog.emit("intro")		
