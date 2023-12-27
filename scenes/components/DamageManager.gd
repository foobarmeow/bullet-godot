class_name DamageManager extends Node2D

signal health_updated

@export var initial_health: int
@export var can_hit: bool = true
@export var can_damage: bool = true
@export var hit_grace: int = 0
@export var hit_color: Color = Color.RED

var health: int = initial_health:
	set(v):
		health = v
		health_updated.emit(health)

var taking_damage: bool = false
	
func _ready():
	health = initial_health
	
func take_damage(parent: Node2D, enemy: Node2D, dmg: int):
	if !can_hit || taking_damage:
		return
		
	if health <= 0:
		return

	if !can_damage: 
		return
		
	health -= dmg
	
	# free the enemy right away...
	enemy.queue_free()

	damage_animate(parent)
	

var tweens: Array[Tween]
func damage_animate(parent: Node2D):
	for t in tweens:
		t.kill()
	tweens = []
	
	var initial_position = parent.position
	var initial_color = parent.modulate
	var color_tween = get_tree().create_tween()
	tweens.append(color_tween)
	
	color_tween.tween_property(parent, "modulate", Color.RED, .05)
	color_tween.tween_property(parent, "modulate", initial_color, .05)
	var tween = get_tree().create_tween()
	tweens.append(tween)
		# 5 frames
	for i in 5:
		var p = Vector2(parent.position.x+randi_range(-2, 2), parent.position.y+randi_range(-2,2))
		tween.tween_property(parent, "position", p, .025)
	# Back to initial position
	tween.tween_property(parent, "position", initial_position, .025)
	
		

