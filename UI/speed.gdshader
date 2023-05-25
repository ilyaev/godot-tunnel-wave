shader_type canvas_item;

uniform float progress = .5;

void fragment() {
	vec2 uv = UV;
	vec3 borderColor = vec3(.9);

	vec3 col = vec3(0.);

	col = max(col, step(0.01, abs(uv.x-.5)-.488)*borderColor);
	col = max(col, step(0.01, abs(uv.y-.5)-.46)*borderColor);
	col = max(col, vec3(uv.x, 1.-uv.x,0.)*step(uv.x, progress));

	COLOR = vec4(col,1.);
}
