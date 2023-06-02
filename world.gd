extends Node3D

@onready var tunnel = $tunnel
@onready var ship = $head/ship
@onready var splash = $splash_screen
@onready var anykey = $splash_screen/continue_text
@onready var pbar = $splash_screen/pbar
var http_request = HTTPRequest.new()

var T = 0

func _ready():
	ship.is_started = true
	splash.show()
	tunnel.translate(Vector3(0, 0, 0))
	ship.connect("bullet_hit", tunnel.bullet_hit)
	add_child(http_request)
	send_stat("start")

func send_stat(action, body = {}):
	var user_id = OS.get_unique_id()
	body.id = user_id
	body.action = action
	var bodyStr = JSON.new().stringify(body)


func _process(delta):
	tunnel.translate(Vector3(0, 0, delta * ship.velocity))
	tunnel.startube.set_instance_shader_parameter("ship_speed", max(0.3, ship.velocity))

	T += delta

	if T < 3:
		pbar.size.x = 1000*T/3
		anykey.hide()
		return
	else:
		pbar.hide()

	if fmod(T*2, 2) > 1:
		anykey.show()
	else:
		anykey.hide()


func restart():
	tunnel.transform.origin = Vector3(0,0,0)
	tunnel.restart()
	ship.restart()

func _input(event):
	if T > 3.:
		if splash.visible:
			splash.hide()
			restart()


	if event is InputEventKey:
		if event.keycode == 83 && event.pressed == false:
			var img = get_viewport().get_texture().get_image()
			img.save_png("UI/save%s.png" % [randi_range(10,1000)])
