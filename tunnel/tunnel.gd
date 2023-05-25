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
	var num_coins = 8
	var helix_len = 1
	var angle_shift = randf_range(0, 2*PI) - PI
	var z_width = .2 + randf_range(0, .5)

	var rn = randf_range(0, 1.)
	if rn > .5:
		helix_len = 2
		num_coins = 16
		z_width *= .8;

	if rn > .8:
		num_coins = 8;
		z_width = 0.;
		helix_len = 1;

	for i in range(0, num_coins):
		var expl = coin.instantiate()
		var angle = ((helix_len * 2) * PI) / num_coins
		expl.y = round(position.z + i)
		var z_shift = i * z_width;
		var pos = Vector3(
			sin(angle_shift + angle * i)*(1 + randf_range(-.1, .1)),
			cos(angle_shift + angle * i)*(1 + randf_range(-.1, .1)),
			-position.z - 6 - z_shift
		)
		expl.position = center + Vector3(0,0,-position.z - 2 - z_shift)
		expl.target_position = center + pos
		add_child(expl)
