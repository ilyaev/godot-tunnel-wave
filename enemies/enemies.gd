extends Node3D

var loop = Vector2(0, 0)
var size
var spacing

var enemy = preload("res://enemies/enemy.tscn")

func n21(vector2):
	return GlobalNoise.n21(vector2)

func _process(delta):
	for i in  range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < loop.x:
			mesh.queue_free()
		else:
			var pos = Vector3(0,0,0)
			var n = n21(Vector2(mesh.y/5., 2.145))

			pos.z = -mesh.y * size * spacing
			pos.x = n*2.
			pos.y = (fposmod(n*100.33, 1.) - 0.5) * 3

			mesh.set_position(pos)

func spawn(index):
	var n = n21(Vector2(index, 1.2))
	if n > .5:
		var mesh = enemy.instantiate()
		mesh.x = 0
		mesh.y = index
		add_child(mesh)
