shader_type spatial;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}


float field(vec2 uvo, float index) {
	vec2 uv = fract(uvo);
	vec2 id = floor(uvo);
	vec3 col = vec3(0.);

	uv.x += sin(index);

	float n = n21(vec2(id.y+index*3.2, id.x-index*43.));

	return step(0.5, abs(uv.y - n)) * pow(.05/abs(uv.x - .5 - (fract(n*34.22)*.3)*2. - .3), 3.5);
}

void fragment() {
	vec3 col = vec3(0.);

	float stars = 0.;

	for(int i = 0 ; i < 3 ; i++) {
		stars = max(stars, field(UV * vec2(20., float(i+1)*10.) - vec2(0., TIME*pow(float(4 - i+1), 1.2)), float(i)));
	}
	ALBEDO = stars * vec3(0.9, .3, .1);
	ALPHA = step(12.2, (ALBEDO.r + ALBEDO.g + ALBEDO.b) / 3.);
}
