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

func n21(x, y):
	return GlobalNoise.n21(x, y) * 1.3

func step(edge,value):
	return 1.0 - max(sign(edge-value),0.0)

func _process(delta):
	T += delta
	for i in range(get_child_count()):
		var mesh = get_child(i)

		var n = mesh.n.x

		var radius = base_radius

		var pos = Vector3(0,0,0)

		var angle = a_step * mesh.x + mesh.y*(2 * n)

		var rotatingN = mesh.n.y

		angle += sin(T + rotatingN * 5.) * step(.7, rotatingN) * (PI + PI/8*rotatingN)

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

			generate_rock_noise(mesh)

			var major_episode = floor(mesh.y / GameConfig.MAJOR_TUBE_EPISODE_SIZE)
			var major_noise = n21(major_episode, GlobalNoise.seed * 3)
			if major_noise > .5:
				mesh.hide()
			else:
				mesh.show()
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
			generate_rock_noise(mesh)

			add_child(mesh)

func generate_rock_noise(mesh):
	mesh.n = Vector3(n21(mesh.y/10., 12.345), GlobalNoise.r21(mesh.y, 44.33) * 3, 0)

func restart():
	for i in range(get_child_count()):
		get_child(i).queue_free()
	create_mesh()
