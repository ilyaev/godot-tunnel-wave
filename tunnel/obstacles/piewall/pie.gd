extends MeshInstance3D

var x = 0
var y = 0
var surface = SurfaceTool.new()
var mat = null
var density = 6
var radius = 2
var height = 2
var vertices = []
var uv_scale = 1.
var uv_split = false
var opening = 1.

func _ready():
	build_mesh()
	build_material()
	build_collision()

func build_mesh():
	var _mesh = ArrayMesh.new()

	if _mesh.get_surface_count() > 0:
		_mesh.surface_remove(0)

	surface.clear()
	surface.begin(Mesh.PRIMITIVE_TRIANGLES)

	var verts = []
	var verts2 = []
	verts.resize(density)
	verts2.resize(density)

	var step = 2 * PI / density

	for n in range(density):
		var x = radius * sin(step * n)
		var y = radius * cos(step * n)

		verts[n] = Vector3(x,y,0)
		verts2[n] = verts[n] - Vector3(0,0,height)

	surface.set_smooth_group(-1)


	#FACE
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(Vector3(0,0,0))
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(verts[0])

	# #CAP
	# surface.set_uv(Vector2(0,0))
	# surface.add_vertex(verts[0])
	# surface.set_uv(Vector2(0,1))
	# surface.add_vertex(verts2[0])
	# surface.set_uv(Vector2(1,1))
	# surface.add_vertex(verts2[1])

	# surface.set_uv(Vector2(0,0))
	# surface.add_vertex(verts2[1])
	# surface.set_uv(Vector2(0,1))
	# surface.add_vertex(verts[1])
	# surface.set_uv(Vector2(1,1))
	# surface.add_vertex(verts[0])


	#LEFT Quad
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts2[0])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts[0])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(-Vector3(0,0,height))

	surface.set_uv(Vector2(0,0))
	surface.add_vertex(-Vector3(0,0,height))
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts[0])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(Vector3(0,0,0))

	#RIGHT Quad
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts2[1])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(-Vector3(0,0,height))


	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(-Vector3(0,0,height))
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(Vector3(0,0,0))

	surface.index()
	surface.generate_normals()
	surface.generate_tangents()


	surface.commit(_mesh)
	vertices = verts

	set_mesh(_mesh)


func build_material():
	if mat == null:
		mat = StandardMaterial3D.new()
		mat.set_albedo(Color(1,0.5,0,1))
	set_surface_override_material(0, mat)
	print(['uvScale', uv_scale])
	set_instance_shader_parameter('uvScale', float(uv_scale))
	set_instance_shader_parameter('x', float(x))
	set_instance_shader_parameter('y', float(y))
	set_instance_shader_parameter('uvSplit', uv_split)
	set_instance_shader_parameter('opening', float(opening))

func build_collision():
	create_trimesh_collision()
	var body = get_child(0)
	body.set_collision_layer(4)
	body.set_collision_mask(1)
	var shape = body.get_child(0)
	shape.shape.set_margin(.1)