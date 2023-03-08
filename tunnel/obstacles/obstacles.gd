extends Node3D

var loop = Vector2(0, 0)
var size
var spacing

var piewall = preload("res://tunnel/obstacles/piewall/piewall.tscn")


func n21(vector2):
	return GlobalNoise.n21(vector2)

func _process(delta):
	for i in range(get_child_count()):
		var mesh = get_child(i)
		if mesh.y < (loop.x - 8):
			mesh.queue_free()
		else:
			var pos = Vector3(0,0,0)
			pos.z = -mesh.y * size * spacing
			mesh.set_position(pos)
	pass


func spawn(index, density, radius, height):
	var n = n21(Vector2(index*22., 44.322))
	if n > .8:
		var obs = piewall.instantiate()
		obs.y = index;
		obs.radius = 1
		obs.density = density
		obs.radius = radius
		obs.height = height
		obs.fill.clear()
		for f in obs.density:
			obs.fill.append(roundi(randf()))
		add_child(obs)
