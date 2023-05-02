shader_type spatial;

instance uniform float ship_speed;

float n21(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898 + floor(1.), 4.1414))) * 43758.5453);
}

float get_shape(vec2 uvo, float index, float frame) {
	vec2 uv = fract(uvo);
	vec2 id = floor(uvo);
	vec3 col = vec3(0.);

	uv.x += sin(index);

	float n = n21(vec2(id.y+index*3.2, id.x-index*43.2));
	if (n21(vec2(frame, 4334.22)) > .1) {
		return step(0.5, abs(uv.y - n)) * pow(.05/abs(uv.x - .5 - (fract(n*34.22)*.3)*2. - .3), 3.5);
	} else {
		return step(0.5, abs(uv.y - n)) * pow(.05/abs(uv.y - .5 - (fract(n*34.22)*.3)*2. - .3), 3.5);
	}
}


float field(vec2 uvo, float index) {
	float current = get_shape(uvo, index, floor(TIME));
	float next = get_shape(uvo, index, floor(TIME)+1.);
	return mix(current, next, fract(TIME));
}

void fragment() {
	vec3 col = vec3(0.);

	float stars = 0.;
	float t = TIME * (ship_speed/25.);

	for(int i = 0 ; i < 10 ; i++) {
		stars = max(stars, field(UV * vec2(20., float(i+1)*10.) - vec2(0., t*pow(float(4 - i+1), 1.2)), float(i)));
	}
	ALBEDO = stars * vec3(0.9, .3, .1);
	ALPHA = step(12.2, ALBEDO.r);
}
