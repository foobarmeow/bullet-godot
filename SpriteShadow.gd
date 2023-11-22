extends Sprite2D

@export var sprite_height: int

var lights: Array
var light_location: Vector2


# Called when the node enters the scene tree for the first time.
func _ready():
	lights = Util.search_tree_for(get_tree().root.get_children(), func(c):
		return c is Light2D
	)
	
	if len(lights) == 0:
		print_debug("SpriteShadow found no lights")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var light: Light2D
	var diff = 0
	for l in lights:
		var this_diff = position.distance_to(l.position)
		if this_diff > diff:
			diff = this_diff
			light = l
			
	if light == null:
		return

	material.set_shader_parameter("lightLocation", to_local(light.position))
	material.set_shader_parameter("shadowLocation", position)
	#material.set_shader_parameter("lightWidth", light.get_width())
	#material.set_shader_parameter("lightWidth", 50)
	#material.set_shader_parameter("lightHeight", light.get_height())
	#material.set_shader_parameter("lightHeight", 50)
	material.set_shader_parameter("lightStrength", light.energy)
	material.set_shader_parameter("spriteHeight", sprite_height)
	pass
