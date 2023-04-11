@tool
extends Node3D

@export var autofire = false

var a = 5.
var velocity = 0.
var max_velocity = 8.
var radius = 4.5
var posVelocity = Vector2(0.,0.)
var posAcceleration = Vector2(0., 0.)


var accelerationRange = .9
var speedRange = 1.9
var accelerationDecay = 0.15


var T = 0

signal bullet_hit(particle: MeshInstance3D, ray: RayCast3D, bullet)

@onready var bullet = preload("res://player/bullets/bullet.tscn")
@onready var camera = $"../camera"
@onready var area = $mesh/Area3D
@onready var area_shape = $mesh/Area3D/CollisionShape3D
@onready var ray = $mesh/ray
@onready var ray2 = $mesh/ray2
@onready var ray3 = $mesh/ray3
@onready var ray4 = $mesh/ray4
@onready var ray5 = $mesh/ray5
@onready var bullet_point = $bullet_place

func _ready():
	pass # Replace with function body.


func _process(delta):
	T += delta
	velocity = min(max_velocity, velocity + a*delta)
	if T > 0.25 && autofire:
		var b = bullet.instantiate()
		b.set_meta('side', 'player')
		b.init(position)
		b.connect("bullet_hit", bullet_hit_func)
		add_child(b)
		T = 0
	pass



func _physics_process(delta):
	if ray.is_colliding() :
		velocity = -3

	if ray2.is_colliding():
		velocity = 0
		posVelocity = Vector2(-.05, 0)

	if ray3.is_colliding():
		velocity = 0
		posVelocity = Vector2(.05, 0)

	if ray4.is_colliding():
		velocity = 0
		posVelocity = Vector2(0., .05)

	if ray5.is_colliding():
		velocity = 0
		posVelocity = Vector2(0., -.05)

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	posAcceleration.x += input_dir.x * delta * .12
	posAcceleration.y -= input_dir.y * delta * .12

	posAcceleration = posAcceleration.clamp(-Vector2(accelerationRange, accelerationRange), Vector2(accelerationRange, accelerationRange))

	if posAcceleration.x != 0:
		posAcceleration.x -= posAcceleration.x * accelerationDecay

	if posAcceleration.y != 0:
		posAcceleration.y -= posAcceleration.y * accelerationDecay

	posVelocity += posAcceleration
	posVelocity = posVelocity.clamp(-Vector2(speedRange, speedRange), Vector2(speedRange, speedRange))

	if posVelocity.x != 0:
		posVelocity.x -= posVelocity.x * accelerationDecay

	if posVelocity.y != 0:
		posVelocity.y -= posVelocity.y * accelerationDecay


	position.x += posVelocity.x
	position.y += posVelocity.y

	camera.look(position)

	rotate_y(delta * PI/4)

	basis = Basis().rotated(Vector3.FORWARD, PI*posVelocity.x*3).rotated(Vector3.RIGHT, PI*posVelocity.y*3)

	if Input.is_action_just_pressed("ui_accept"):
		var b = bullet.instantiate()
		b.set_meta('side', 'player')
		b.init(position + bullet_point.position + Vector3(0,0,-0.5))
		b.connect("bullet_hit", bullet_hit_func)
		get_parent().add_child(b)

		var b2 = bullet.instantiate()
		b2.set_meta('side', 'player')
		b2.init(position + bullet_point.position * Vector3(-1, 1, 1) + Vector3(0,0,-0.5))
		b2.connect("bullet_hit", bullet_hit_func)
		get_parent().add_child(b2)

func bullet_hit_func(pos : Vector3, ray : RayCast3D, bullet):
	var particle = ray.get_collider().get_parent()
	bullet_hit.emit(particle, ray, bullet)
	pass

func _on_area_3d_body_entered(body):
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsShapeQueryParameters3D.new()
	query.shape = area_shape.shape
	query.transform = area_shape.global_transform
	query.set_collision_mask(2 | 4)
	query.margin = 1
	var result = space_state.intersect_shape(query)
	if result.size() > 0:
		var layer = result[0].collider.collision_layer
		var collider = result[0].collider
		result = space_state.get_rest_info(query)
		var collision_point = result.point
		var collision_normal = result.normal.normalized()
		if layer == 2:
			posVelocity = -Vector2(collision_point.x, collision_point.y)*.2
			velocity = 0

