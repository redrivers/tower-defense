extends KinematicBody2D

export (int) var speed = 200

var _target = Vector2(randi() % 1280, randi() % 720)
var _timer = null
var _velocity = Vector2()

onready var Animation: AnimatedSprite = get_node("AnimatedSprite")
onready var health_bar = get_node("health")

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "move_random")
	_timer.set_wait_time(2)
	_timer.set_one_shot(false)
	_timer.start()
		
		
func _physics_process(delta):
	if health_bar.value <= 0:
		return
	
	_velocity = position.direction_to(_target) * speed
	# look_at(target)
	if position.distance_to(_target) > 5:
		_velocity = move_and_slide(_velocity)


func move_random():
	_target = Vector2(randi() % 1280, randi() % 720)


func death():
	Animation.animation = "death"
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "destroy")
	_timer.set_wait_time(3)
	_timer.start()


func destroy():
	queue_free()
