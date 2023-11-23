extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	start_movers(get_children())

func start_movers(nodes: Array[Node]):
	for n in nodes:
		if n.get_child_count() > 0:
			start_movers(n.get_children())
		if n is Mover:
			n.player = $Player
			n.begin()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_lights_out_trigger_area_entered(area):
	$CanvasModulate.show()
	
	var l = $KillLightHolder/KillLight
	var initial_energy = l.energy
	l.energy = 0
	l.show()
	
	while l.energy < initial_energy:
		await get_tree().create_timer(.1).timeout
		l.energy += .1
	l.reparent($Player)
	$LightsOutTrigger.disconnect("area_entered", _on_lights_out_trigger_area_entered)
