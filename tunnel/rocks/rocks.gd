extends Node3D

var base_radius = 3
var density = 11
var depth = 32
var size = .3
var T = 0
var spacing = 2.
var a_step = PI*2 / density

var loop = Vector2(0, 0)
var rock = preload("res://tunnel/rocks/rock.tscn")

func _ready():
	create_mesh()

func n21(vector2):
	return GlobalNoise.n21(vector2)


func get_radius(y, t):
	return base_radius + (abs(n21(Vector2(y, t)) * .5) - .25);

func step(edge,value):
	return 1.0 - max(sign(edge-value),0.0)

func _process(delta):
	T += delta
	for i in range(get_child_count()):
		var mesh = get_child(i)
		var n = n21(Vector2(mesh.y/15., 12.345))
		var radius = base_radius

		if abs(n) > 0.6:
			radius = lerpf(get_radius(mesh.y, floor(T)), get_radius(mesh.y, ceilf(T)),  fposmod(T, 1.))

		var pos = Vector3(0,0,0)

		var rotatingN = n

		var angle = a_step * mesh.x + mesh.y*(2 * n)

		angle += sin(T + rotatingN*5.)*step(.7, rotatingN)*(PI + PI/8*rotatingN)

		pos.x = sin(angle) * radius
		pos.y = cos(angle) * radius
		pos.z = -mesh.y * size * spacing

		mesh.set_position(pos)

func set_z(z):
	var current_z = floorf(z / (size * spacing))
	if (current_z - loop.x) > 0:
		for i in range(get_child_count()):
			var mesh = get_child(i)
			mesh.y += 1
			mesh.set_instance_shader_parameter('y', float(mesh.y))
		loop.x = current_z
		loop.y = loop.x + depth

func create_mesh():
	loop.x = 0
	loop.y = depth
	for d in range(depth):
		for i in range(density):
			var mesh = rock.instantiate()
			mesh.x = i
			mesh.y = d
			mesh.set_instance_shader_parameter('x', float(mesh.x))
			mesh.set_instance_shader_parameter('y', float(mesh.y))
			add_child(mesh)
