extends Node3D

var y = 0
var noise = Vector3(0,0,0)
var is_target = false
var is_hit = false




func _ready():

	noise = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	if randf() > 0.5:
		is_target = true

	$mesh.set_instance_shader_parameter('y', float(y))
	$mesh.set_instance_shader_parameter('isTarget', is_target)
	# scale = Vector3(max(.5,abs(noise.x)), max(.5,abs(noise.y)), max(.5,abs(noise.z))) * 1.5

	var light_rot = GlobalNoise.n21(y, 23.22)*3
	$lightnet.rotate_z(light_rot * PI * 2)

	for i in range($lightnet.get_child_count()):
		var light = $lightnet.get_child(i)
		light.get_child(0).set_instance_shader_parameter('y', float(y))
		light.get_child(0).set_instance_shader_parameter('x', float(i))
		light.get_child(0).set_instance_shader_parameter('density', randf_range(10.,30.))
		light.get_child(0).set_instance_shader_parameter('flick', randf_range(2.,8.))

	pass


func _process(delta):
	$mesh.rotate_y(delta * PI * noise.y)
	$mesh.rotate_x(delta * PI * noise.x)
	$mesh.rotate_y(delta * PI * noise.z)
	pass


func take_hit(collision_point : Vector3):
	if is_target:
		if !is_hit:
			get_parent().get_parent().coins_explode(collision_point)
			Score.play_boom()
		is_hit = true
		queue_free()
	pass
