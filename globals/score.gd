extends Node

var score

@onready var Hud = $"../world/hud"

func _ready():
    score = 0


func coin():
    score += 1
    Hud.set_distance(str(score))

func set_speed(speed):
    Hud.set_speed(str(speed))