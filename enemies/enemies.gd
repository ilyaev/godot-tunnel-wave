extends Node3D

var loop = Vector2(0, 0)
var size
var spacing

var enemy = preload("res://enemies/enemy.tscn")

func n21(x, y):
	return GlobalNoise.r21(x, y)

func _process(_delta):
	for i in  range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < loop.x:
			mesh.queue_free()
		else:
			var pos = Vector3(0,0,0)
			var n = n21(mesh.y/5., 2.145)

			pos.z = -mesh.y * size * spacing
			pos.x = n*4.
			pos.y = (fposmod(n*100.33, 1.) - 0.5) * 4

			mesh.set_position(pos)

func spawn(index, bullet_hit_func):
	var n = n21(index, 42)
	if n > .2:
		var mesh = enemy.instantiate()
		mesh.x = 0
		mesh.y = index
		mesh.connect("bullet_hit", bullet_hit_func)
		add_child(mesh)
