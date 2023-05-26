extends Control

@onready var distance = $distance
@onready var speed_rect = $speedrect
@onready var life_rect = $liferect
@onready var stage = $stage


var prev_speed = 0
var min_speed = 10.0
var drop_speed = false
var T = 0

func _ready():
	pass # Replace with function body.


func _process(delta):
	if drop_speed:
		T += delta
		speed_rect.get_material().set_shader_parameter("progress", (min_speed + (prev_speed - min_speed) * (1. - T*4.) - min_speed) / (Score.stage_max_speed - min_speed))
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
		speed_rect.get_material().set_shader_parameter("progress", (float(speed) - min_speed) / (Score.stage_max_speed - min_speed))
		prev_speed = float(speed)

func set_life(life):
	life_rect.get_material().set_shader_parameter("lives", float(life))

func set_stage(stage_str):
	stage.text = 'Stage ' + stage_str
