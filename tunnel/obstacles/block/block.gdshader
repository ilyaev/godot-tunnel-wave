shader_type spatial;

instance uniform float y;
instance uniform bool isTarget;

void fragment() {

	vec2 uv = fract(UV * vec2(3.,2.));

	vec3 borderColor = vec3(.9, .3, .1);
	vec3 borderColorBlue = vec3(.1, .3, .9);

	vec3 col = pow(.2/abs(uv.x - .99), 1.2) * borderColor;
	col += pow(.2/abs(uv.x - .01), 1.2) * borderColor;

	col += pow(.2/abs(uv.y - .99), 1.2) * borderColor;
	col += pow(.2/abs(uv.y - .01), 1.2) * borderColor;

	if (isTarget) {
		vec3 targetColor = vec3(.9, .3, .1);

		// multicolor
		targetColor.r = (cos(TIME*4. + y)*.5 + .5)*.9;
		targetColor.g = (cos(TIME*9. - y)*.5 + .5)*.3;
		targetColor.b = (sin(TIME*2. + y)*.5 + .5)*.9;

		// blink
		targetColor *= sin(TIME*(12. + abs(sin(y))*8.) + y) *.5 + .5;
		EMISSION = targetColor * col;
	}

	ALBEDO = col;
}
