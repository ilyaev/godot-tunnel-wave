extends Node3D

var x : int = 0
var y : int = 0
var fire_speed = 0.3

var T = 0

@onready var bullet = preload("res://player/bullets/bullet.tscn")


func _ready():
	fire_speed += randf()

func _process(delta):
	T += delta
	rotate_z(delta * sin(y)*PI/4)
	if T > fire_speed:
		T = 0
		var b = bullet.instantiate()
		b.init(position + Vector3(0, 0, 1.5))
		b.direction = Vector3(0 ,0, -1)
		# b.connect("bullet_hit", bullet_hit_func)
		get_parent().get_parent().add_child(b)
		fire_speed = 0.3 + randf()

