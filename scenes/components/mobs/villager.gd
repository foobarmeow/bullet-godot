extends PathFollow2D

enum VillagerType { A = 1, B, C, D}
enum VillagerRole {STANDER, FARMER}

@export var role: VillagerRole = VillagerRole.STANDER
@export var villager_type: VillagerType = VillagerType.D:
	set(v):
		villager_type = v
		_ready()
@export var move_wait_min: int = 2
@export var move_wait_max: int = 3
@export var move_step: float = 0.002
@export var max_move_slice: float = 0.05
var move_timer: SceneTreeTimer

func _ready():
	$AnimatedSprite2D.play("idle_%s" % villager_type)
	
	if role == VillagerRole.FARMER:
		new_move_timer()
		
		# Set a random amount of progress
		# so that many farmers are dispersed
		progress_ratio = randf_range(0, 1)
		
	
var moving: bool = false
var this_move: float = 0.0
var this_slice: float = 0.0
func _process(delta):
	if !moving:
		return
	
	this_move += move_step*delta
	progress_ratio += move_step*delta
	if this_move >= this_slice:
		new_move_timer()
	
func new_move_timer():
	if !get_tree():
		return
	if move_timer:
		move_timer.disconnect("timeout", set_moving)
		
	$AnimatedSprite2D.play("idle_%s" % villager_type)
	moving = false
	move_timer = get_tree().create_timer(randi_range(move_wait_min, move_wait_max))
	move_timer.connect("timeout", set_moving)
	this_move = 0.0
	this_slice = randf_range(0.01, max_move_slice)
		
func set_moving():
	moving = true
	$AnimatedSprite2D.play("walk_%s" % villager_type)
