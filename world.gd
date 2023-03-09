extends Node3D

@onready var tunnel = $tunnel
@onready var ship = $head/ship

func _ready():
	tunnel.translate(Vector3(0, 0, 0))
	ship.connect("bullet_hit", tunnel.bullet_hit)


func _process(delta):
	tunnel.translate(Vector3(0, 0, delta * ship.velocity))
