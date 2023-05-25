extends Control

@onready var distance = $distance
@onready var speed_rect = $speedrect
@onready var life_rect = $liferect


var prev_speed = 0
var min_speed = 10.0
var drop_speed = false
var T = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if drop_speed:
		T += delta
		speed_rect.get_material().set_shader_parameter("progress", (min_speed + (prev_speed - min_speed) * (1. - T*4.) - min_speed) / 4)
		if T > .25:
			drop_speed = false
			T = 0
	pass


func set_distance(d):
	distance.text = d

func set_speed(speed):
	if float(speed) - min_speed < .01:
		T = 0
		drop_speed = true

	if !drop_speed:
		speed_rect.get_material().set_shader_parameter("progress", (float(speed) - min_speed) / 4)
		prev_speed = float(speed)

func set_life(life):
	life_rect.get_material().set_shader_parameter("lives", float(life))