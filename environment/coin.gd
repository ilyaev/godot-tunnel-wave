extends Node3D

var x = 0
var y = 0
var hit = false
var target_position
var delay = 0
var T = 0

func _ready():
	delay = randf_range(0, .15)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	if T < delay:
		return
	else:
		show()
	rotate_z(delta * sin(y)*PI)
	rotate_y(delta * cos(y)*PI*.5)
	rotate_x(delta * cos(y+sin(y))*.3)
	if target_position:
		position = position.move_toward(target_position, delta*10)
	pass

func take_hit(mask):
	queue_free()
	if typeof(mask) == 2:
		Score.coin()
	hit = true

func attract(target_pos, delta):
	target_position = false
	position = position.move_toward(Vector3(target_pos.x, target_pos.y, position.z), delta*3)

func is_goodie():
	return true
