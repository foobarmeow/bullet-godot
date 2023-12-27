@tool
extends Node2D

@export var enabled: bool:
	set(v):
		enabled = v
		_ready()
@export var reveal_type: Constants.RevealType:
	set(v):
		reveal_type = v
		_ready()
@export var fade_distance: int = 200:
	set(v):
		fade_distance = v
		_ready()
@export var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		c.reveal_type = reveal_type
		c.player = player
		c.enabled = enabled
		c.fade_distance = fade_distance

