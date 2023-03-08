shader_type spatial;

varying vec3 vertex_position;

instance uniform float x;
instance uniform float y;
instance uniform bool border;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {

	vec2 uv = fract(UV - vec2(0., 0.));

	vec3 col = pow(.2/uv.x, 1.2) * vec3(.9, .3, .1);
	col += pow(.2/abs(uv.y - 1.), 1.2) * vec3(.9, .3, .1);
	col += pow(.2/(uv.y - uv.x), 1.2) * vec3(.9, .3, .1);

	col /= 3.;

	ALBEDO = col;
	ALPHA = clamp(1. - smoothstep(-15., -21., vertex_position.z)*.5, 0., 1.);
}
