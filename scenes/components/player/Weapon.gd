extends Node2D

@export var projectile_component: PackedScene
@export var firing_arc: int = 10
@export var num_projectiles: int = 10
@export var speed: int = 250
@export var cooldown: int = 2
@export var debug: bool = true
@export var projectile_damage: int = 10

var on_cooldown: bool = false

func fire():
	if on_cooldown:
		return
	on_cooldown = true

	$AnimationPlayer.play("fire")
	$AnimationPlayer.animation_finished.connect(func(_a):
		$AnimationPlayer.play("rack")
		$AnimationPlayer.animation_finished.connect(func(_a):
			on_cooldown = false
		, CONNECT_ONE_SHOT)
	, CONNECT_ONE_SHOT)
	
	for i in num_projectiles:
		# Random angle within firing arc
		var offset = deg_to_rad(randi_range(-firing_arc/2, firing_arc/2))
		
		# Aim this projectile at our sample "aiming" ray
		# rotated by the offset
		var projectile_vector = $Ray.target_position.rotated(offset)
		
		var r = RayCast2D.new()
		add_child(r)
		r.target_position = projectile_vector
		r.collision_mask = $Ray.collision_mask
		
		# Force the ray to update
		r.force_raycast_update()
		
		# shoot out a projectile 
		var p = projectile_component.instantiate()
		p.position = $Muzzle.global_position
		
		# If colliding, we want the vector only to be of 
		# magnitude to the target
		# otherwise we want it to fly off somewhere else
		if r.is_colliding():
			var c = r.get_collider()
			p.target = c.position
			if c.has_method("take_damage_from"):
				c.take_damage_from(projectile_damage, null, r.target_position.normalized())
		else:
			p.target = to_global(r.target_position)

		# Add the projectile to the scene
		owner.add_child(p)
		
		# free the ray
		r.queue_free()

func reset_cooldown():
	on_cooldown = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())

	var a = get_angle_to(Vector2.ZERO)
	if a > -0.6 && a < 1.6:
		$ReticleSprite.flip_v = true
	else: 
		$ReticleSprite.flip_v = false
