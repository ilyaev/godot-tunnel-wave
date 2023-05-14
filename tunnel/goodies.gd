extends Node3D

var coin = preload("res://environment/coin.tscn")
# var coin = preload("res://enemies/enemy.tscn")

var size
var spacing
var loop = Vector2(0, 0)

func n21(x, y):
	return GlobalNoise.r21(x, y)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in  range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < loop.x:
			mesh.queue_free()
		# else:
		# 	var pos = Vector3(0,0,0)
		# 	var n = n21(mesh.y/5., 2.145)

		# 	pos.z = -mesh.y * size * spacing
		# 	pos.x = n*4.
		# 	pos.y = (fposmod(n*100.33, 1.) - 0.5) * 4

		# 	mesh.set_position(pos)


func spawn(index):
	var n = abs(n21(index, 2.145))
	if n > .3:
		var c = coin.instantiate()

		c.x = 0
		c.y = index

		var pos = Vector3(0,0,0)
		var nn = n21(c.y/5., 2.145)

		pos.z = -c.y * size * spacing
		pos.x = nn*4.
		pos.y = (fposmod(nn*100.33, 1.) - 0.5) * 4

		c.position = pos

		add_child(c)

