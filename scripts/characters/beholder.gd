extends KinematicBody2D


var attack = 30
var attack_speed = 0.5
var class_type = "beholder"
var speed = 250

var _attack_target
var _attack_timer = null
var _is_attacking = false
var _is_dead = false
var _size
var _target
var _timer = null
var _velocity = Vector2()

onready var Animation: AnimatedSprite = get_node("AnimatedSprite")
onready var collision = get_node("collision")
onready var health_bar: ProgressBar = get_node("health")

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
	
	var random_num = randf()
	if random_num < 0.6:
		_size = 1
	elif random_num < 0.9:
		_size = 0.5
	elif random_num < 0.98:
		_size = 2
	else:
		_size = 5
		
	set_scale(Vector2(_size, _size))
	attack = int(attack * _size)
	attack_speed = attack_speed * _size
	speed = speed / _size
	
	health_bar.max_value = health_bar.max_value * _size
	health_bar.value = health_bar.max_value
	
	

func _process(delta):
	if _attack_target != null and !_is_attacking:
		_attack_timer.connect("timeout", self, "attack")
		_attack_timer.set_wait_time(attack_speed)
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
		
	Animation.flip_h = _velocity.x < 0


func attack():
	if health_bar.value <= 0:
		return
	
	if !is_instance_valid(_attack_target) or !_attack_target.receive_damage(randi() % attack):
		_attack_timer.disconnect("timeout", self, "attack")
		_is_attacking = false
		_attack_target = null
		return
		
	Animation.animation = "attack" + str(randi() % 2 + 1)
	Animation.flip_h = _attack_target.position.x - position.x < 0
	

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
	collision.disabled = true
	$health.visible = false
	var score = get_parent().get_node("scoreboard/background/score/goblins/score")
	score.text = str(int(score.text) + 1)
	
	Animation.animation = "death"
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "destroy")
	_timer.set_wait_time(3)
	_timer.start()
	_is_dead = true


func destroy():
	queue_free()
