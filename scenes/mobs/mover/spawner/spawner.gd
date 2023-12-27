class_name Spawner extends Node2D

@export var type: Constants.SpawnerType
@export var bullet: PackedScene
@export var speed: int = 900
@export var dir: Vector2
var v: Vector2

func _ready():
	$FireTimer.timeout.connect(fire)

func fire():
	if bullet == null:
		return

	match type:
		Constants.SpawnerType.TARGET:
			var v = dir * speed
			add_bullet(v)
		Constants.SpawnerType.DIR:
			var v = dir * speed
			add_bullet(v)
		Constants.SpawnerType.PLUS:
			for v in [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]:
				add_bullet(v*speed)
		Constants.SpawnerType.CIRCLE:
			var steps = 8
			var angle = 0.0
			var step = TAU/steps
			for i in steps:
				var v = Vector2.UP.rotated(angle) * speed
				add_bullet(v)
				angle += step
				
	get_parent().get_node("AnimatedSprite2D").play("fire")

func add_bullet(v):
	var b = bullet.instantiate()
	b.position = global_position
	get_tree().root.add_child(b)
	b.velocity = v
	b.fire()
				
				
			
			


func _on_animated_sprite_2d_animation_finished():
	pass
