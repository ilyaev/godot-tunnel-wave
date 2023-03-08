extends Node3D

var T = 0

func _process(delta):
	T += delta
	if T > 0.7:
		queue_free()
	pass
