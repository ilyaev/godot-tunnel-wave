extends Node3D

@onready var tunnel = $tunnel
@onready var ship = $head/ship
@onready var splash = $splash_screen

var T = 0

func _ready():
	splash.show()
	tunnel.translate(Vector3(0, 0, 0))
	ship.connect("bullet_hit", tunnel.bullet_hit)


func _process(delta):
	T += delta
	tunnel.translate(Vector3(0, 0, delta * ship.velocity))
	tunnel.startube.set_instance_shader_parameter("ship_speed", max(0.3, ship.velocity))

func restart():
	tunnel.transform.origin = Vector3(0,0,0)
	tunnel.restart()
	ship.restart()

func _input(event):
	if T > 1.:
		splash.hide()
		ship.is_started = true
