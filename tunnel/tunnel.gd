extends Node3D

var size = .3
var spacing = 2.

var T = 0
var hidden_rocks = {}

var explosion = preload("res://player/explosions/explosion.tscn")
var coin = preload("res://environment/coin.tscn")

@onready var enemies  = $enemies
@onready var tube = $tube
@onready var obstacles = $obstacles
@onready var rocks = $rocks
@onready var startube = $startube
@onready var goodies = $goodies


func n21(x, y):
	return GlobalNoise.r21(x, y)

func _ready():
	obstacles.size = size
	obstacles.spacing = spacing
	obstacles.length_base = tube.length
	enemies.size = size
	enemies.spacing = spacing
	goodies.size = size
	goodies.spacing = spacing

	coins_explode(Vector3(0,0,-7))

func _process(delta):
	T += delta

	var loop = rocks.loop

	basis = Basis().rotated(Vector3.FORWARD, PI/32 * sin(T))

	var current_z = floorf(position.z / (size * spacing))

	tube.set_z(position.z)
	rocks.set_z(position.z)
	startube.position.z = -position.z - 9.;

	obstacles.sync_with_tube(position.z, tube.get_density, tube.radius, tube.length )

	enemies.loop = loop
	goodies.loop = loop

	# if (current_z - loop.x) > 0:
	# 	spawn_target(loop.y)

	if (current_z - loop.x) > 0:
		spawn_goodies(loop.y)

func spawn_goodies(index):
	goodies.spawn(index)

func spawn_target(index):
	enemies.spawn(index, bullet_hit_enemy)

func bullet_hit_enemy(mesh, ray : RayCast3D, bullet):
	if mesh.has_method("take_hit"):
		mesh.take_hit(ray.get_collision_point())

func bullet_hit(mesh, ray : RayCast3D, bullet):
	if ray.get_parent().get_meta("side", "ray") == mesh.get_meta("side", "mesg"):
		return

	bullet.queue_free()
	var expl = explosion.instantiate()
	expl.position = ray.get_collision_point() # mesh.get_parent().position
	get_parent().add_child(expl)

	if mesh.get_parent().has_method("take_hit"):
		mesh.get_parent().take_hit(ray.get_collision_point())
	else:
		if mesh.has_method("take_hit"):
			mesh.take_hit(ray.get_collision_point())
		else:
			mesh.queue_free()



func coins_explode(center):
	print([center, position])
	var num_coins = 8
	for i in range(0, num_coins):
		var expl = coin.instantiate()
		expl.y = round(position.z + i)
		var pos = Vector3(sin((2*PI/num_coins) * i)*(1 + randf_range(-.1, .1)), cos((2*PI/num_coins) * i)*(1 + randf_range(-.1, .1)), -position.z)
		expl.position = center + pos
		add_child(expl)