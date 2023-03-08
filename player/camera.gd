extends Camera3D

func look(pos):
	basis = Basis().rotated(Vector3.UP, -pos.x * PI/8).rotated(Vector3.RIGHT, pos.y * PI/8)
	position.y = pos.y / 2.;
	position.x = pos.x / 2.;
