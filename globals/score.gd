extends Node

var score
var stage = 1
var stage_max_speed = 13
var starting_max_speed = 13
var is_game_over = false

@onready var Hud = $"../world/hud"
@onready var GameOver = $"../world/gameover"
@onready var Tunnel = $"../world/tunnel"
@onready var World = $"../world"

func _ready():
	score = 0


func coin():
	score += 1
	Hud.set_distance(str(score))

func set_speed(speed):
	if speed > stage_max_speed:
		next_stage()
	else:
		Hud.set_speed(str(speed))

func set_lives(lives):
	Hud.set_life(lives)

func next_stage():
	stage += 1
	stage_max_speed += 2
	Hud.set_stage(str(stage))
	Tunnel.next_stage()

func game_over():
	is_game_over = true
	Hud.hide()
	GameOver.show()
	GameOver.start()
	GameOver.set_score(score)
	pass

func start_game():
	is_game_over = false
	Hud.show()
	GameOver.hide()
	set_lives(5)
	stage = 1
	Hud.set_stage(str(stage))
	stage_max_speed = starting_max_speed
	score = -1
	coin()
	World.restart()
