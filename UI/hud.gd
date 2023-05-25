extends Control

@onready var distance = $distance
@onready var speed_rect = $speedrect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_distance(d):
	distance.text = d

func set_speed(speed):
	speed_rect.get_material().set_shader_parameter("progress", (float(speed) - 10.) / 4)
