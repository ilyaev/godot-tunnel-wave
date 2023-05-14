extends Node3D

var x = 0
var y = 0
var hit = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_z(delta * sin(y)*PI)
	rotate_y(delta * cos(y)*PI*.5)
	rotate_x(delta * cos(y+sin(y))*.3)
	pass

func take_hit(mask):
	queue_free()
	Score.coin()
	hit = true

func attract(target_pos, delta):
	position = position.move_toward(Vector3(target_pos.x, target_pos.y, position.z), delta*3)
