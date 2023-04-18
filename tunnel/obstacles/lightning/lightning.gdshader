shader_type spatial;

uniform sampler2D noise;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 14.1414))) * 43758.5453);
}

void fragment() {
	vec2 uv = UV;
	vec3 color = vec3(.1, .3, .9);

	float n = texture(noise, uv/2. + vec2(TIME*.1, TIME-texture(noise, uv/20.).r )).r - .5;

	float mag = sin(uv.x*PI)*.05;

	vec3 col = pow(mag/abs(uv.y - .5 - n*(.2 + .2*abs(sin(TIME*10. + cos(uv.y))))), 1.2) * color;


	EMISSION = col * 3.;
	ALPHA = smoothstep(0.1, 1., col.b);
}
