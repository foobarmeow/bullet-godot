extends Node2D

@export var lit_material: CanvasItemMaterial
@export var line_manager: Node2D



var paused: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	start_movers(get_children())
	debug_state()
	
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
	


