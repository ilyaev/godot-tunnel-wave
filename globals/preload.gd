extends Node3D

var explMaterial = preload("res://materials/explosion_shader_material.tres")
var burnerMaterial = preload("res://materials/burner_material.tres")

func _ready():
	var b = GPUParticles3D.new()
	b.process_material = burnerMaterial
	b.emitting = true
	add_child(b)
	
	var e = GPUParticles3D.new()
	e.process_material = explMaterial
	e.emitting = true
	add_child(e)



func _process(delta):
	pass
	
