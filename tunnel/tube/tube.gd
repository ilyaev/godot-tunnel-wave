extends Node3D

var radius = 2.5
var density = 0
var length = 3
var depth = 10
var current = 0
var episode_size = 0
var _seed = 0

var section_scene = preload("res://tunnel/tube/tubesection.tscn")

var T = 0

func _ready():
	density = 5
	_seed = GlobalNoise.seed
	episode_size = GameConfig.TUBE_EPISODE_SIZE
	create_mesh()

func _process(delta):
	T += delta


func n21(vector2):
	return GlobalNoise.noise.get_noise_2d(vector2.x, vector2.y) + .5

func get_density(z):
	var episode = floor(z / episode_size)
	return clamp(floor(2 + (GameConfig.MAX_TUBE_SECTIONS - 1) * n21(Vector2(episode + 0.0, _seed))), 3, GameConfig.MAX_TUBE_SECTIONS)

func set_z(z):
	var p = floorf(z/length)
	if (p - current) > 0:
		current = p
		for i in get_child_count():
			var section = get_child(i)
			section.y += 1
			sync_section(section)

func sync_section(section):
	section.set_instance_shader_parameter('y', float(section.y))
	section.position.z = -section.y * length
	var section_density = get_density(section.y)

	if section_density != get_density(section.y - 1) or section_density != get_density(section.y + 1):
		section.border = true
	else:
		section.border = false
	section.set_instance_shader_parameter('border', section.border)

	if section_density != section.density:
		if section.x > section_density:
			section.hide()
		else:
			section.show()

		var a = 2*PI/section_density
		var x = sin(a * section.x)*radius
		var y = cos(a * section.x)*radius
		section.position = Vector3(x,y,-section.y * length)

		var _basis = Basis().scaled(Vector3(2*radius*tan(PI/section_density),1.,length))
		section.basis = _basis.rotated(Vector3.FORWARD, a * section.x)

		section.density = section_density

	if !section.get_parent():
		add_child(section)

	if GlobalNoise.noise.get_noise_2d(section.y, section.x) > 0.25:
		section.light.show()
	else:
		section.light.hide()


func create_mesh():
	for y in depth:
		for x in GameConfig.MAX_TUBE_SECTIONS:
			var mesh = section_scene.instantiate()
			mesh.x = x
			mesh.y = y
			mesh.set_instance_shader_parameter('x', float(mesh.x))
			sync_section(mesh)
