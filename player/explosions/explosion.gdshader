shader_type spatial;

void fragment() {

	vec2 uv = UV;

	vec3 targetColor = vec3(.9, .3, .1);
	// vec3 borderColor = vec3(.9, .3, .1);

	// vec3 col = length(uv) * borderColor;

	// // multicolor
	// targetColor.r = (cos(TIME*4.)*.5 + .5)*.9;
	// targetColor.g = (cos(TIME*9.)*.5 + .5)*.3;
	// targetColor.b = (sin(TIME*2.)*.5 + .5)*.9;

	// // blink
	// targetColor *= sin(TIME*(12.)*8.) *.5 + .5;

	EMISSION = vec3(1.)*10.;
	// // Place fragment code here.
}
