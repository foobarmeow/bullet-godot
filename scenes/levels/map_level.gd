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
