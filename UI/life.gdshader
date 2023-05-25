shader_type canvas_item;

uniform float total_lives = 5.;
uniform float lives = 5.;

void fragment() {
	// Place fragment code here.
	vec2 uv = fract(UV * vec2(total_lives, 0.));
	vec2 id = floor(UV * vec2(total_lives, 0.));
	vec3 borderColor = vec3(.9);

	vec3 bar_color = vec3(.3 + (total_lives - lives) * .15, .8-((total_lives - lives)*.15),.1);

	vec3 col = vec3(0.);

	col = max(col, step(0.01, abs(UV.x-.5)-.487)*borderColor);
	col = max(col, step(0.01, abs(UV.y-.5)-.46)*borderColor);

	if (id.x < lives && lives > 0.) {
		col = max(col, step(abs(uv.x-.5)-.35, .1) * bar_color);
	}

	COLOR = vec4(col, 1.);
}
