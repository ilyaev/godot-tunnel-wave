extends Node3D

var a = 0.
var velocity = 0.
var direction = Vector3(0,0,1)
var T = 0

signal bullet_hit(pos, ray, bullet)

@onready var ray = $ray
@onready var light = $light
@onready var mesh = $mesh

# func _ready():
# 	if direction.z < 0:
# 		mesh.get_active_material(0).emission = Color(1,0,0,1)

func _process(delta):
	T += 0
	velocity = velocity + a * delta
	position += direction * velocity
	if T > 3:
		queue_free()
	if direction.z < 0 && T > 0.2:
		light.hide()
	pass

func _physics_process(_delta):
	if ray.is_colliding():
		bullet_hit.emit(ray.get_collision_point(), ray, self)

func init(pos):
	position = pos
	a = -1 * direction.z
