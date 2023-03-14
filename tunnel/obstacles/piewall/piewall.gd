extends Node3D

var density = 8
var fill = []
var y = 0
var radius = 3.5
var height = .5
var mat = StandardMaterial3D.new()
var scale_vector = Vector3(1, 1, 1)
var floating = false

var pie = preload("res://tunnel/obstacles/piewall/pie.tscn")
var shader_code : Shader = preload("res://tunnel/obstacles/piewall/pie.gdshader")

func _ready():
	rotate_z(PI/density + randi_range(0, density) * PI*2/density)
	build_material()
	var uv_scale =  1
	var uv_split = false
	var opening = 0.

	# if density < 7:
	# 	uv_scale = randi_range(1, 3)

	if uv_scale == 1 && randf() > .7:
		uv_split = true

	# if randf() > .5:
	# 	opening = randf()

	for i in density:
		if fill[i] == 1:
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
			add_child(pi)

	if floating:
		var next_pos = get_next_random_position(0)
		set_position(Vector3(next_pos.x, next_pos.y, position.z))



func get_next_random_position(index):
	return Vector2(randf() * 3 - 1.5, randf() * 3 - 1.5)



func build_material():
	mat = ShaderMaterial.new()
	mat.set_shader(shader_code)

func _process(delta):
	if floating:
		rotate_z(delta * PI/4)
	pass
