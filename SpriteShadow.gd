extends Sprite2D



var light_location: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var light = get_node("/root/Heyo/Light")
	var shadowPosition = Vector2(-10, -10)
	
	print(light.texture.get_width(), shadowPosition)

	material.set_shader_parameter("lightLocation", light.position)
	material.set_shader_parameter("shadowLocation", shadowPosition)
	#material.set_shader_parameter("lightWidth", light.texture.get_width())
	material.set_shader_parameter("lightWidth", 20)
	material.set_shader_parameter("lightHeight", light.texture.get_height())
	material.set_shader_parameter("lightStrength", light.energy)
	material.set_shader_parameter("spriteHeight", texture.get_height())
	pass
