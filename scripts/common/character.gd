extends Node


onready var hp_bar = get_parent().get_node("health")


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if hp_bar.value <= 0:
        # zero hp = death
        get_parent().death()
