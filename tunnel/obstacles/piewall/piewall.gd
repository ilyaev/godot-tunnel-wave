extends Node3D

var density = 8
var fill = []
var y = 0
var radius = 3.5
var height = .5
var mat = StandardMaterial3D.new()
var scale_vector = Vector3(1, 1, 1)
var floating = false
var T = 0
var cur_pos = Vector2(0,0)
var next_pos = Vector2(0,0)
var is_rotating = false
var is_flickering = false

var pie = preload("res://tunnel/obstacles/piewall/pie.tscn")
var shader_code : Shader = preload("res://tunnel/obstacles/piewall/pie.gdshader")

func _ready():
	# rotate_z(PI/density + randi_range(0, density) * PI*2/density)
	build_material()
	var uv_scale =  1
	var uv_split = false
	var opening = 0.

	is_rotating = false
	var n = abs(GlobalNoise.r21(y, 43))
	if n > .17:
		is_rotating = true
		if n > .2:
			is_flickering = true

	# if density < 7:
	# 	uv_scale = randi_range(1, 3)

	if uv_scale == 1 && randf() > .7:
		uv_split = true

	# if randf() > .5 && floating:
	# 	opening = randf()

	for i in density:
		if fill[i] > 0:
			var pi = pie.instantiate()
			pi.density = density
			pi.mat = mat
			pi.y = y
			pi.x = i
			pi.radius = radius
			pi.height = height
			pi.basis = pi.basis.rotated(Vector3.FORWARD, i * PI*2/density).scaled(scale_vector)
			pi.uv_scale = uv_scale
			pi.uv_split = uv_split
			pi.opening = opening
			pi.fill = fill[i]
			add_child(pi)


func get_next_random_position(index):
	var n = GlobalNoise.r21(index, 234)
	return Vector2(n * 3, fposmod(n*323.22, 1.) * 3)



func build_material():
	mat = ShaderMaterial.new()
	mat.set_shader(shader_code)

func _process(delta):
	T += delta
	if is_rotating:
		var wave = 0
		if randf() > .7 && is_flickering:
			wave = sin(T*6.5)
		else:
			wave = cos(T*2.5)
		rotate_z(delta * (PI/3 * (GlobalNoise.r21(y, 34)*2) - PI/6) * wave)

	if floating:
		rotate_z(delta * PI/4)

		cur_pos = get_next_random_position(floor(T))
		next_pos = get_next_random_position(floor(T) + 1)

		var progress = fposmod(T, 1.)

		set_position(Vector3(lerpf(cur_pos.x, next_pos.x, progress), lerpf(cur_pos.y, next_pos.y, progress), position.z))

	pass
