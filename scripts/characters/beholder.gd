extends KinematicBody2D

export (int) var speed = 250

const ATTACK_POWER = 30
const ATTACK_SPEED = 0.5

var class_type = "beholder"

var _attack_target
var _attack_timer = null
var _is_attacking = false
var _target
var _timer = null
var _velocity = Vector2()

onready var Animation: AnimatedSprite = get_node("AnimatedSprite")
onready var health_bar = get_node("health")

# Called when the node enters the scene tree for the first time.
func _ready():
	_target = position
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "move_random")
	_timer.set_wait_time(4)
	_timer.set_one_shot(false)
	_timer.start()
	move_random()
	
	_attack_timer = Timer.new()
	add_child(_attack_timer)
		

func _process(delta):
	if _attack_target != null and !_is_attacking:
		_attack_timer.connect("timeout", self, "attack")
		_attack_timer.set_wait_time(ATTACK_SPEED)
		_attack_timer.set_one_shot(false)
		_attack_timer.start()
		_is_attacking = true


func _physics_process(delta):
	if health_bar.value <= 0 or _attack_target != null:
		return

	_velocity = position.direction_to(_target) * speed
	
	if position.distance_to(_target) > 5:
		Animation.animation = "move"
		_velocity = move_and_slide(_velocity)
		var slide_count = get_slide_count()
		if slide_count:
			var collision = get_slide_collision(slide_count - 1)
			var collider = collision.collider
			if "class_type" in collider and collider.class_type != class_type:
				_attack_target = collider
	else:
		Animation.animation = "default"


func attack():
	if health_bar.value <= 0:
		return

	Animation.animation = "attack" + str(randi() % 2 + 1)
	
	if !is_instance_valid(_attack_target) or !_attack_target.receive_damage(ATTACK_POWER):
		_attack_timer.disconnect("timeout", self, "attack")
		_is_attacking = false
		_attack_target = null
	

func receive_damage(amount):
	health_bar.value -= amount
	if health_bar.value <= 0:
		return false
	
	return true


func move_random():
	if health_bar.value <= 0:
		return
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
