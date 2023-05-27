extends Node3D

var coin = preload("res://environment/coin.tscn")

var size
var spacing
var loop = Vector2(0, 0)

func n21(x, y):
	return GlobalNoise.r21(x, y)

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in  range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < loop.x:
			mesh.queue_free()


func spawn(index):
	var n = abs(n21(index, 2.145))
	if n > .3:
		var c = coin.instantiate()

		c.x = 0
		c.y = index

		var pos = Vector3(0,0,0)

		pos.z = -c.y * size * spacing
		pos.x = GlobalNoise.n21(c.y*3, 23.22) * 4
		pos.y = GlobalNoise.n21(c.y*3, 43.22) * 4

		c.position = pos

		add_child(c)


func restart():
	for i in range(get_child_count()):
		get_child(i).queue_free()
