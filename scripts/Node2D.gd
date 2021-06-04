extends Node2D

const Beholder = preload("res://scenes/characters/beholder.tscn")
const Goblin = preload("res://scenes/characters/goblin.tscn")

const TIMEOUT = 4

var timeout_beholders: float = 0
var timeout_beholders_max: float = 0
var timeout_goblins: float = 0
var timeout_goblins_max: float = 0

onready var TextNode = get_node("Label")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	timeout_beholders_max = randi() % TIMEOUT
	timeout_goblins_max = randi() % TIMEOUT
	
	
func _process(delta):
	if timeout_beholders < timeout_beholders_max:
		timeout_beholders += delta
	else:
		timeout_beholders = 0
		timeout_beholders_max = randi() % TIMEOUT
	
		var beholder = Beholder.instance()
		beholder.position = Vector2(500,350)
		add_child(beholder)
		
	if timeout_goblins < timeout_goblins_max:
		timeout_goblins += delta
	else:
		timeout_goblins = 0
		timeout_goblins_max = randi() % TIMEOUT
	
		var goblin = Goblin.instance()
		goblin.position = Vector2(1000, 400)
		add_child(goblin)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
