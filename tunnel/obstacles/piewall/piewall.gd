extends Node3D

var density = 8
var fill = []
var y = 0
var radius = 3.5
var height = .5
var mat = StandardMaterial3D.new()
var scale_vector = Vector3(1, 1, 1)

var pie = preload("res://tunnel/obstacles/piewall/pie.tscn")
var shader_code : Shader = preload("res://tunnel/obstacles/piewall/pie.gdshader")

func _ready():
	rotate_z(PI/density + randi_range(0, density) * PI*2/density)
	build_material()
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
			add_child(pi)



func build_material():
	mat = ShaderMaterial.new()
	mat.set_shader(shader_code)

func _process(delta):
	pass
