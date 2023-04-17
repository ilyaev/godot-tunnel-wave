extends Node3D

var y = 0
var noise = Vector3(0,0,0)
var is_target = false




# Called when the node enters the scene tree for the first time.
func _ready():

	noise = Vector3(randf_range(-1,1),randf_range(-1,1),randf_range(-1,1))
	if randf() > 0.5:
		is_target = true

	$mesh.set_instance_shader_parameter('y', float(y))
	$mesh.set_instance_shader_parameter('isTarget', is_target)
	# scale = Vector3(max(.5,abs(noise.x)), max(.5,abs(noise.y)), max(.5,abs(noise.z))) * 1.5
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(delta * PI * noise.y)
	rotate_x(delta * PI * noise.x)
	rotate_y(delta * PI * noise.z)
	pass


func take_hit(collision_point : Vector3):
	if is_target:
		queue_free()
	pass
