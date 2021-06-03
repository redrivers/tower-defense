extends KinematicBody2D

export (int) var speed = 200

var _target = Vector2(randi() % 1280, randi() % 720)
var _timer = null
var _velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
    _timer = Timer.new()
    add_child(_timer)
    _timer.connect("timeout", self, "move_random")
    _timer.set_wait_time(2)
    _timer.set_one_shot(false)
    _timer.start()
        
        
func _physics_process(delta):
    _velocity = position.direction_to(_target) * speed
    # look_at(target)
    if position.distance_to(_target) > 5:
        _velocity = move_and_slide(_velocity)


func move_random():
    _target = Vector2(randi() % 1280, randi() % 720)
