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
		var R = (2 * radius * tan(PI / density)) / (2 * sin(PI / density))
		spawn(loop.y, density, R, length)

func spawn(index, density, radius, height):
	var n = n21(Vector2(index*22., 44.322))
	if n > .1:
		if n > .6:
			spawn_floater(index, density, radius, height)
		else:
			spawn_piewall(index, density, radius, height)

func spawn_floater(index, density, radius, height):
	var obs = piewall.instantiate()
	obs.y = index;
	obs.density = randi_range(3,6)
	obs.radius = radius * .3
	obs.height = height * .05
	obs.fill.clear()
	for f in obs.density:
		obs.fill.append(1)
	obs.set_position(Vector3(0, 0, -index * length_base + length_base / 2.))
	obs.floating = true
	add_child(obs)

func spawn_piewall(index, density, radius, height):
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
