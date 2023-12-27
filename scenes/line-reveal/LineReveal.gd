@tool
extends Line2D


enum RevealType {MOUSE, PLAYER = -1}
@export var reveal_type: RevealType
@export var player: Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	match reveal_type:
		RevealType.MOUSE:
			material.set_shader_parameter("player_position", to_local(get_global_mouse_position()))
		RevealType.PLAYER:
			material.set_shader_parameter("player_position", to_local(player.position))

