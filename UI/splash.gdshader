shader_type canvas_item;

void fragment() {
	// Place fragment code here.
	if (COLOR.r > .5) {
		COLOR.r = sin(TIME*2.+cos(TIME*2./sin(TIME*3.)));
	}
}
