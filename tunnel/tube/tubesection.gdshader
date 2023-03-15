shader_type spatial;

varying vec3 vertex_position;

instance uniform float x;
instance uniform float y;
instance uniform bool border;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}


float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

void fragment() {
	// Place fragment code here.
	vec2 uv = fract(UV * vec2(border ? 16. : 4., border ? 8. : 2.)); // for CUBE
	vec2 uv2 = abs(UV - vec2(.5));

	float n = n21(vec2(y, 32.22));

	ALBEDO = pow(.05 / abs(uv.x - 0.49), 3.2) * vec3(.9, .3, .1);
	ALBEDO += pow(.05 / abs(uv.y - 0.49), 3.2) * vec3(.9, .3, .1);
	ALBEDO /= 2.;

	if (border) {
		ALBEDO += pow(.05 / abs(uv2.x - 0.49), 3.2 - sin(TIME)) * vec3(.3, .9, .1);
		ALBEDO += pow(.05 / abs(uv2.y - 0.49), 3.2) * vec3(.3, .9, .1);
	}

	ALPHA = clamp(.5 - smoothstep(-15., -21., vertex_position.z) * .5, 0., 1.);

	if (n > .5) {
//		ALBEDO = vec3(1.- fract(n*3240.772), 1.- fract(n*102.12), 1. - fract(n*10.32));
		ALBEDO = vec3(.9);
		ALBEDO += pow(.05 / abs(uv2.y - 0.49), 3.2) * vec3(.3, .9, .1);
		ALBEDO += pow(.05 / abs(uv2.x - 0.49), 3.2 - sin(TIME)) * vec3(.3, .9, .1);
		ALPHA = clamp(.9 - smoothstep(-15., -21., vertex_position.z) * .9, 0., 1.);
	}

}
