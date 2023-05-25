shader_type spatial;

void fragment() {

	vec2 uv = fract(UV * vec2(3.,2.));

	vec3 targetColor = vec3(.9, .3, .1);

	EMISSION = (.5 / pow(length(uv - .5), 1.1))*targetColor*3.;
}
