extends Node3D

var size = .3
var spacing = 2.

var T = 0
var hidden_rocks = {}

var explosion = preload("res://player/explosions/explosion.tscn")

@onready var enemies  = $enemies
@onready var tube = $tube
@onready var obstacles = $obstacles
@onready var rocks = $rocks


func n21(x, y):
	return GlobalNoise.r21(x, y)

func _ready():
	obstacles.size = size
	obstacles.spacing = spacing
	obstacles.length_base = tube.length
	enemies.size = size
	enemies.spacing = spacing

func _process(delta):
	T += delta

	var loop = rocks.loop

	basis = Basis().rotated(Vector3.FORWARD, PI/32 * sin(T))

	var current_z = floorf(position.z / (size * spacing))

	tube.set_z(position.z)
	rocks.set_z(position.z)

	obstacles.sync_with_tube(position.z, tube.get_density, tube.radius, tube.length )

	enemies.loop = loop

	if (current_z - loop.x) > 0:
		spawn_target(loop.y)

func spawn_target(index):
	enemies.spawn(index)


func bullet_hit(mesh, ray : RayCast3D):
	var expl = explosion.instantiate()
	expl.position = mesh.get_parent().position
	add_child(expl)

	if mesh.has_method("take_hit"):
		mesh.take_hit(ray.get_collision_point())
	else:
		mesh.queue_free()



