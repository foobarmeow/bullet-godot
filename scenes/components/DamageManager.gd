class_name DamageManager extends Node2D

signal health_updated
signal invuln_updated

@export var health: int
@export var invuln: bool = false
@export var hit_grace: int = 0
@export var hit_color: Color = Color.RED
@export var invuln_time: float

var _health: int = health:
	set(v):
		_health = v
		health_updated.emit(_health)
		
var _invuln: bool = invuln:
	set(v):
		_invuln = v
		invuln_updated.emit(_invuln)
		
var taking_damage: bool = false
	
func _ready():
	_health = health
	
func end_invuln():
	_invuln = false
	
func take_damage(parent: Node2D, enemy: Node2D, dmg: int):
	# free the enemy right away...
	enemy.queue_free()
	
	if _invuln:
		return
	

	if invuln_time > 0:
		_invuln = true
		get_tree().create_tween().tween_callback(end_invuln).set_delay(invuln_time)
		
	if _health <= 0:
		return

	_health -= dmg
	damage_animate(parent)
	

var initial_color: Color
var tweens: Array[Tween]
func damage_animate(parent: Node2D):
	var sprite = parent.get_node("AnimatedSprite2D")
	if !sprite:
		print_debug("no sprite to modulate when taking damage! fuck!")
		return
		
	if !initial_color:
		initial_color = sprite.self_modulate
		
		
	for t in tweens:
		t.kill()
		
	if len(tweens) > 0:
		# Reset the modulate in case 
		# we killed the tween modulating it
		sprite.self_modulate = initial_color
		
	tweens = []
		
	var initial_position = parent.position
	var initial_color = parent.modulate
	var color_tween = get_tree().create_tween()
	tweens.append(color_tween)
	
	#color_tween.tween_property(sprite, "self_modulate", Color.RED, .05)
	#color_tween.tween_property(sprite, "self_modulate", initial_color, .05)
	invuln_animation(sprite, color_tween)
	
	var tween = get_tree().create_tween()
	tweens.append(tween)
	
	for i in 5:
		var p = Vector2(parent.position.x+randi_range(-2, 2), parent.position.y+randi_range(-2,2))
		tween.tween_property(parent, "position", p, .025)
	# Back to initial position
	tween.tween_property(parent, "position", initial_position, .025)
	
func invuln_animation(sprite: Node2D, color_tween: Tween):
	if invuln_time <= 0:
		return
		
	var total_invuln_steps = 10
	var invuln_step = invuln_time / total_invuln_steps
	
	
	var vis_color = sprite.self_modulate
	var invis_color = Color(vis_color, 0.0)
	
	for i in total_invuln_steps/2:
		color_tween.tween_property(sprite, "modulate", invis_color, invuln_step)
		color_tween.tween_property(sprite, "modulate", vis_color, invuln_step)
	
