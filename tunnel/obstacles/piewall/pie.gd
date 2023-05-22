@tool
extends MeshInstance3D

var x = 0
var y = 0
var surface = SurfaceTool.new()
var mat = null
@export var density = 6
var radius = 2
var height = 2
var vertices = []
var uv_scale = 1.
var uv_split = false
var opening = 1.
@export var fill = .5
var _mesh = ArrayMesh.new()
var inactive = false
var gravity = Vector3.DOWN * 9.8
var velocity = Vector3(0,0,0)
var acceleration = Vector3(0,0,0)
var TTL = 3
var T = 0
var rot_speed
var is_target = false
var thread = Thread.new()
var mutex = Mutex.new()
var start
var end

func _ready():
	rot_speed = PI * randf_range(0.5,3.5)
	var callable = Callable(self, 'async_build')
	thread.start(callable)

func async_build():

	mutex.lock()

	build_mesh()
	build_material()
	call_deferred("build_collision")

	mutex.unlock()

func _process(delta):

	if thread.is_started() && !thread.is_alive():
		thread.wait_to_finish()

	if inactive == false:
		return
	acceleration += gravity * delta
	position += acceleration * delta

	var center = Vector3(-vertices[1].x/2, -vertices[1].y/2, -height/2)


	transform = transform.rotated(Vector3.FORWARD, -x * PI*2/density - PI/density).translated(center).rotated(Vector3.FORWARD, delta * rot_speed).translated(-center).rotated(Vector3.FORWARD, x * PI*2/density + PI/density)

	T += delta
	if T > TTL:
		queue_free()


func build_mesh():
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
		var x1 = radius * sin(step * n)
		var y1 = radius * cos(step * n)

		verts[n] = Vector3(x1,y1,0)
		verts2[n] = verts[n] - Vector3(0,0,height)

	surface.set_smooth_group(-1)

	if (fill < 1):
		build_partial_mesh(verts, verts2)
	else:
		build_full_mesh(verts, verts2)

	surface.index()
	surface.generate_normals()
	surface.generate_tangents()


	surface.commit(_mesh)
	vertices = verts

	set_mesh(_mesh)

func add_quad(v1,v2,v3,v4):
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(v1)
	surface.set_uv(Vector2(1,0))
	surface.add_vertex(v2)
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(v4)

	surface.set_uv(Vector2(1,0))
	surface.add_vertex(v2)
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(v3)
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(v4)

func build_partial_mesh(verts, verts2):
	var projection = Vector3(0,0,0)
	var center1 = Vector3((verts[0].x - projection.x) * (1. - fill), (verts[0].y - projection.y) * (1. - fill),0)
	var center2 = Vector3((verts[1].x - projection.x) * (1. - fill), (verts[1].y - projection.y) * (1. - fill),0)
	var center1_back = center1 - Vector3(0,0,height)
	var center2_back = center2 - Vector3(0,0,height)

	#FACE
	add_quad(verts[0],verts[1], center2, center1)

	#CAP
	add_quad(center2, center2_back, center1_back, center1)

	#RIGHT Quad
	add_quad(verts[0], center1, center1_back, verts2[0])

	#LEFT Quad
	add_quad(verts[1], verts2[1], center2_back, center2)

func build_full_mesh(verts, verts2):
	var center = Vector3(0, 0, 0)
	var center_back = center - Vector3(0, 0, height)

	#FACE
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))

	surface.add_vertex(center)

	surface.set_uv(Vector2(1,1))
	surface.add_vertex(verts[0])

	#CAP
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[0])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts2[0])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(verts2[1])

	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts2[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(verts[0])


	#LEFT Quad
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts2[0])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts[0])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(center_back)

	surface.set_uv(Vector2(0,0))
	surface.add_vertex(center_back)
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts[0])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(center)

	#RIGHT Quad
	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(verts2[1])
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(center_back)


	surface.set_uv(Vector2(0,0))
	surface.add_vertex(verts[1])
	surface.set_uv(Vector2(0,1))
	surface.add_vertex(center_back)
	surface.set_uv(Vector2(1,1))
	surface.add_vertex(center)


func build_material():
	if mat == null:
		mat = StandardMaterial3D.new()
		mat.set_albedo(Color(1,0.5,0,1))
	set_surface_override_material(0, mat)
	set_instance_shader_parameter('uvScale', float(uv_scale))
	set_instance_shader_parameter('x', float(x))
	set_instance_shader_parameter('y', float(y))
	set_instance_shader_parameter('uvSplit', uv_split)
	set_instance_shader_parameter('opening', float(opening))
	set_instance_shader_parameter('fill', float(fill))
	set_instance_shader_parameter('isTarget', is_target)


func build_collision():
	create_trimesh_collision()
	var body = get_child(0)
	body.set_collision_layer(4)
	body.set_collision_mask(1)
	var shape = body.get_child(0)
	shape.shape.set_margin(.1)


func take_hit(collision_point : Vector3):
	if !is_target:
		# is_target = true
		# set_instance_shader_parameter('isTarget', is_target)
		return
	if inactive == true:
		pass
	else:
		inactive = true
	acceleration = Vector3(randf_range(-1,1),randf_range(5,15),-randf_range(30,46))

