extends TextureRect


func _ready():
	pass # Replace with function body.


func _process(delta):
	pass

func _input(event):
	if event is InputEventScreenTouch || event is InputEventMouseButton:
		if event.pressed:
			if _is_point_inside_joystick_area(event.position):
				Score.shoot()



func _is_point_inside_joystick_area(point: Vector2) -> bool:
	var x: bool = point.x >= global_position.x and point.x <= global_position.x + (size.x * get_global_transform_with_canvas().get_scale().x)
	var y: bool = point.y >= global_position.y and point.y <= global_position.y + (size.y * get_global_transform_with_canvas().get_scale().y)
	return x and y
