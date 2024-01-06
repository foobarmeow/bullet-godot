extends RigidBody2D

var target: Vector2
var hit_threshold: int = 5
var speed: float = 5.5
var splatter_radius: float = 2.5

var target_vector: Vector2


func _ready():
	target_vector = target - position

func _physics_process(delta):
	if target:
		var c = move_and_collide(target_vector * (speed*delta))
		if c:
			var collider = c.get_collider()
			if collider.has_method("take_damage"):
				collider.take_damage(10, self)
			splatter(global_position)
			queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func splatter(p: Vector2):
	for i in 5:
		var s = Sprite2D.new()
		s.texture = $SplatterSprite.texture
		s.scale = $SplatterSprite.scale
		s.add_to_group("splatter")
		s.position = p
		s.position.x += randf_range(-splatter_radius, splatter_radius)
		s.position.y += randf_range(-splatter_radius, splatter_radius)
		get_tree().root.add_child(s)
