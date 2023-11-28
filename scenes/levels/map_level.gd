extends Node2D

@export var lit_material: CanvasItemMaterial
@export var line_manager: Node2D



var paused: bool


# Called when the node enters the scene tree for the first time.
func _ready():
#	start_movers(get_children())
#	debug_state()
	pass
	
func debug_state():
	if $DebugSpot != null:
		$Player.position = $DebugSpot.position
		_on_lights_out_trigger_area_entered(null)

					
func start_movers(nodes: Array[Node]):
	for n in nodes:
		if n.get_child_count() > 0:
			start_movers(n.get_children())
		if n is Mover:
			n.player = $Player
			n.begin()
			n.dead.connect(_on_mover_dead)
	

func _on_lights_out_trigger_area_entered(area):
	# Darken the scene
	$CanvasModulate.show()

	# Lighten the material used by enemies/player
	lit_material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		
	# Show the light at 0 energy
	var l = $KillLightHolder/KillLight
	#var initial_energy = l.energy
	#l.energy = 0
	#l.show()
	
	
	# Increase the energy over time
#	while l.energy < initial_energy:
#		await get_tree().create_timer(.25).timeout
#		l.energy += .1
#
#	# Parent it to the player and disconnect this signal
#	l.reparent($Player)
#	l.translate(Vector2.ZERO)
	$LightsOutTrigger.disconnect("area_entered", _on_lights_out_trigger_area_entered)
	
	# Show the lit path
	line_manager.show()
	line_manager.enabled = true
	line_manager.reveal_type = Constants.RevealType.PLAYER
	
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
	print(dun, dead)
	if dun || dead:
		dun = false
		dead = false
		print('reloading')
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

