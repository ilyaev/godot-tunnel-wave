extends Node3D

var x : int = 0
var y : int = 0

func _process(delta):
	rotate_z(delta * sin(y)*PI/4)
