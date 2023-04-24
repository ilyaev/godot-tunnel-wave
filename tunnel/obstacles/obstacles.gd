extends Node3D

var loop = Vector2(-1, -1)
var size
var spacing
var length_base = 1
var curr_index = -1
var curr_index_block = -1
var prev_block_index = -1

var piewall = preload("res://tunnel/obstacles/piewall/piewall.tscn")
var block = preload("res://tunnel/obstacles/block/block.tscn")


func n21(x, y):
	return GlobalNoise.r21(x, y) * 2.

func _process(_delta):
	for i in range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < (loop.x - 8):
			mesh.queue_free()
	pass

func sync_with_tube(z, densityFunc, radius, length):
	var next_index = floorf(z / length_base)
	if (next_index - curr_index) >= 1:
		curr_index = next_index
		loop.x = next_index
		loop.y = loop.x + 8
		var density = densityFunc.call(loop.y)
		var R = (2 * radius * tan(PI / density)) / (2 * sin(PI / density))
		spawn(loop.y, density, R, length)
#	else:
#		if (next_index - curr_index) >= 1:
#			print([next_index, 'block'])

func spawn(index, density, radius, height):
	var spawned = false
	if fmod(index, 4) == 0:
		var n = abs(n21(index*22., 44.322))
		if n > .1:
			spawned = true
			spawn_piewall(index, density, radius, height)
	else:
		if fmod(index, 3) == 0 && spawned == false:
			var n = abs(n21(index*12., 144.322))
			if n > .3 and (index - prev_block_index) > 6:
				spawned = true
				spawn_block(index)
				prev_block_index = index


func spawn_block(index):
	var obs = block.instantiate()
	obs.y = index
	obs.set_position(Vector3((randf()-.5)*3, (randf()-.5)*3, -index * length_base + length_base / 2.))
	add_child(obs)

func spawn_piewall(index, density, radius, height):
	var obs = piewall.instantiate()
	obs.y = index;
	obs.density = density
	obs.radius = radius
	obs.height = height * .5
	obs.fill.clear()
	var n = randf_range(0, 1)
	for f in obs.density:
		if n > .5:
			if n > .7:
				obs.fill.append(max(.15, min(1., abs(n21(index,f)*1.5))))
			else:
				var angle = 6.28/obs.density * f
				var hn = max(.35, min(.9, abs(GlobalNoise.n21(index + sin(angle) * 3.5, index + cos(angle) * 2.5) * 2)))
				obs.fill.append(hn)
		else:
			if n21(index, f) > .2:
				obs.fill.append(1)
			else:
				obs.fill.append(0)

	if n > .5:
		pass
	else:
		obs.fill[randi_range(0, density-1)] = 0

	obs.set_position(Vector3(0, 0, -index * length_base + length_base / 2.))
	add_child(obs)
