@tool
extends Line2D

var reveal_type: Constants.RevealType
var player: Node2D
var enabled: bool
var fade_distance: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	material.set_shader_parameter("enabled", enabled)
	material.set_shader_parameter("fade_distance", fade_distance)
	match reveal_type:
		Constants.RevealType.MOUSE:
			material.set_shader_parameter("player_position", to_local(get_global_mouse_position()))
		Constants.RevealType.PLAYER:
			material.set_shader_parameter("player_position", to_local(player.position))

