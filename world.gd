extends Node3D

@onready var tunnel = $tunnel
@onready var ship = $head/ship
@onready var hood = $hud

func _ready():
	tunnel.translate(Vector3(0, 0, 0))
	ship.connect("bullet_hit", tunnel.bullet_hit)


func _process(delta):
	tunnel.translate(Vector3(0, 0, delta * ship.velocity))
	tunnel.startube.set_instance_shader_parameter("ship_speed", max(0.3, ship.velocity))
	# hood.set_distance(str(floor(tunnel.position.z)))
