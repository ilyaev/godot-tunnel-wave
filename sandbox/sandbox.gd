extends Node3D


var pieS = preload("res://tunnel/obstacles/piewall/pie.tscn")


var T = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	T += delta
	if T > 0.5:
		T = 0
		var i = randi_range(0,5)
		var density = 6
		var scale_vector = Vector3(1, 1, 1)
		var pie = pieS.instantiate()
		pie.fill = .6
		pie.basis = pie.basis.rotated(Vector3.FORWARD, i * PI*2/density).scaled(scale_vector)
		pie.acceleration = Vector3(randf_range(-10,10),randf_range(5,15),-randf_range(10,16))
		pie.inactive = true
		add_child(pie)
		
	pass
