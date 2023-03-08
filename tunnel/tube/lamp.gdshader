shader_type spatial;

varying vec3 vertex_position;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	ALBEDO = vec3(.1, .5, .1);
	ALPHA = clamp(1. - smoothstep(-15., -21., vertex_position.z)*.5, 0., 1.);
}
