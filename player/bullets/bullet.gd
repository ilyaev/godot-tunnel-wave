extends Node3D

var a = 0.
var velocity = 0.

signal bullet_hit(pos, ray)

@onready var ray = $ray

func _process(delta):
	velocity = velocity + a * delta
	position.z += velocity
	if position.z < -40:
		queue_free()
	pass

func _physics_process(delta):
	if ray.is_colliding():
		bullet_hit.emit(ray.get_collision_point(), ray)
		queue_free()

func init(pos):
	position.x = pos.x + .01
	position.y = pos.y - .01
	position.z = -1.7
	a = -1.
