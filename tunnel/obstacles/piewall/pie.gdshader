
shader_type spatial;

varying vec3 vertex_position;

instance uniform float x;
instance uniform float y;
instance uniform float uvScale;
instance uniform bool uvSplit;
instance uniform float opening;
instance uniform float fill;
instance uniform bool isTarget;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	if (opening > 0.) {
		VERTEX.x += abs(sin(y + TIME / 2.) * opening);
		VERTEX.y += abs(cos(y + TIME / 3.) * opening);
	}
}

void fragment() {

	vec2 uv = fract(UV * vec2(uvScale));

	vec3 borderColor = vec3(.9, .3, .1);
	vec3 borderColorBlue = vec3(.1, .3, .9);

	vec3 targetColor = vec3(.9, .3, .1);

	// multicolor
	targetColor.r = (cos(TIME*4. + y - x)*.5 + .5)*.9;
	targetColor.g = (cos(TIME*9. + y/x)*.5 + .5)*.3;
	targetColor.b = (sin(TIME*2. + y + x)*.5 + .5)*.9;

	// blink
	targetColor *= sin(TIME*(12. + abs(sin(y))*8.) + x + y) *.5 + .5;

	vec3 col = pow(.2/uv.x, 1.2) * borderColor;

	if (fill < 1.) {
		col += pow(.2 / abs(uv.y - 1.), 1.2) * borderColor;
		col += pow((.5 + sin(x + TIME * 3. + y) * .49) / uv.y, 1.2) * borderColorBlue;
		col += pow(.2/abs(uv.x - 1.), 1.2) * borderColor;
		col /= 4.;
	} else {
		col += pow(.2 / abs(uv.y - 1.), 1.2) * borderColor;
		col += pow((.5 + sin(x + TIME * 3. + y) * .49) / abs(uv.y - uv.x), 1.2) * borderColorBlue;
		if (uvSplit) {
			col += pow(.2 / abs((uv.y - uv.x - .5 + sin(TIME + y + x) * .3)), 1.2) * vec3(.9, .3, .1);
		}
		col /= 3.;
	}

	if (isTarget == true) {
		// col = max(col, vec3(1.,0.,0.));
		// col = vec3(1.,0.,0.);
		EMISSION = targetColor * col;
	}

	ALBEDO = col;
	RIM = 0.;
}
