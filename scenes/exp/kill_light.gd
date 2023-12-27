@tool
extends Node2D

@export var draw_circle: bool = false: 
	set(v):
		draw_circle = v
		draw()
@export var circle_radius: int = 100:
	set(v):
		circle_radius = v
		draw()
@export var num_points: int = 100:
	set(v):
		num_points = v
		draw()


signal parry_recharged


func activate():
	$AnimationPlayer.play("parry_activate")


func draw():
	return
	draw_bodies()
	#draw_a_line()

var body_container: Node2D
func draw_bodies():
	if is_instance_valid(body_container):
		body_container.queue_free()
	if !draw_circle:
		return


	# draw many points along a circle
	body_container = Node2D.new()
	add_child(body_container)
	#body_container.owner = get_tree().edited_scene_root
	var radius = circle_radius # or so
	
	
	var last_joint: Joint2D
	
	for i in num_points+1:
		var p = Vector2(1, 0).rotated((TAU/num_points)*i)*radius
		
		var c = CollisionShape2D.new()
		var cs = CircleShape2D.new()
		cs.radius = 2
		c.shape = cs
				
		var r = RigidBody2D.new()
		r.gravity_scale = 0
		r.position = p
		r.add_child(c)
		#c.owner = get_tree().edited_scene_root
		
		body_container.add_child(r)
		#r.owner = get_tree().edited_scene_root
		
		var joint = DampedSpringJoint2D.new()
		r.add_child(joint)
		joint.node_a = joint.get_path_to(r)
		
		if last_joint:
			last_joint.node_b = last_joint.get_path_to(r)
		
		last_joint = joint
		
		#body_container.add_child(joint)
		#joint.owner = get_tree().edited_scene_root
		
		

var line: Line2D
func draw_a_line():
	if is_instance_valid(line):
		line.queue_free()
		
	if !draw_circle:
		return


	# draw many points along a circle
	line = Line2D.new()
	add_child(line)
	line.owner = get_tree().edited_scene_root
	var radius = circle_radius # or so
	for i in num_points+1:
		var p = Vector2(1, 0).rotated((TAU/num_points)*i)*radius
		line.add_point(p)

func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"parry_activate":
			$AnimationPlayer.play("parry_recharge")
		"parry_recharge":
			parry_recharged.emit()
