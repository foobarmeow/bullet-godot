extends Node2D

@export var sprite: Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$SpriteShadow.texture = sprite.texture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass