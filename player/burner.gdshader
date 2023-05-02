shader_type spatial;

varying vec3 vertex_position;

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	// Place fragment code here.
	vec2 uv = UV;

	float d = length(uv - .5);

	vec3 col = vec3(9., .3, .1) * .2/pow(d, 2.2);
	EMISSION = col*abs(sin(vertex_position.z*3. + 4.5));
}
