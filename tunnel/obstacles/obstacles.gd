extends Node3D

var loop = Vector2(-1, -1)
var size
var spacing
var length_base = 1

var piewall = preload("res://tunnel/obstacles/piewall/piewall.tscn")


func n21(vector2):
	return GlobalNoise.n21(vector2)

func _process(_delta):
	for i in range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < (loop.x - 8):
			mesh.queue_free()
	pass

func sync_with_tube(z, densityFunc, radius, length):
	var next_index = floorf(z / length_base)
	if (next_index - loop.x) > 0:
		loop.x = next_index
		loop.y = loop.x + 8
		var density = densityFunc.call(loop.y)
		spawn(loop.y, density, radius, length)

func spawn(index, density, radius, height):
	var n = n21(Vector2(index*22., 44.322))
	if n > .1:
		var obs = piewall.instantiate()
		obs.y = index;
		obs.density = density
		obs.radius = radius
		obs.height = height
		obs.fill.clear()
		for f in obs.density:
			obs.fill.append(roundi(randf()))
		obs.set_position(Vector3(0, 0, -index * length_base + length_base / 2.))
		add_child(obs)
