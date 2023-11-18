extends Node2D

signal wave_complete
signal player_restart

@export var track_timeout: float = 1.5

var player: Area2D
var mob_count: int = INF
var hit = false
var children
var initialized = false

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED

func start(p: Area2D):
	process_mode = Node.PROCESS_MODE_INHERIT
	
	player = p
	
	p.hit.connect(_on_player_hit)
	
	print("starting", mob_count, hit)
	
	show()
	children = get_children()
	mob_count = len(children)
	
	for c in get_children():
		c.exit.connect(_on_mob_exit)
				
		c.player = p
		c.tracking = true
	
	initialized = true
	
	await get_tree().create_timer(track_timeout).timeout
	for c in get_children():
		c.tracking = false
	
func _on_player_hit(lives: int):
	hit = true
	for c in children:
		c.queue_free()
		
	await player.blink()
	hit = false
	
	if player.lives > 0:
		player_restart.emit()

func _on_mob_exit():
	mob_count -= 1
	

func _process(delta):
	if mob_count == 0 && !hit:
		print("wave complete")
		wave_complete.emit()
		queue_free()
	
	
