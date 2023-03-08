shader_type spatial;

varying vec3 vertex_position;

instance uniform float x;
instance uniform float y;

uniform float ship_x;
uniform float ship_y;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

void vertex() {
	vertex_position = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	float n = n21(vec2(x,y));
	vec2 uv = fract(UV * vec2(3.,2.));

	ALBEDO = pow(1.9/length(vertex_position + vec3(0.0,0.0, 4. + sin(TIME) * 3.)), 2.2) * vec3(0.9, 0.3, 0.1);
	ALBEDO += max(vec3(0.), 31.2/pow(length(uv-.5), 2.2) * vec3(.9, .3, .1) * step(.9, n) * sin(TIME + y + x + n*3.));

	ALPHA = 1. - smoothstep(-16., -18., vertex_position.z);
}
