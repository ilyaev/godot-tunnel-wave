shader_type canvas_item;

uniform bool is_gradient = false;
uniform float gradient_shift = 0.3;
uniform vec3 gradient_color = vec3(.1, .3, .8);

const float border = 0.005;
const vec3 borderColor = vec3(.2, .6, .2);
const vec3 fontColor = vec3(.1, .3, .8);


void fragment() {
	vec2 uv = SCREEN_UV - vec2(0.5+sin(TIME+sin(TIME*2. + cos(TIME)*.4))*.4, gradient_shift+sin(TIME*2. + cos(TIME/.2))*.02);

	if (is_gradient == true) {
	   	COLOR.rgb = vec3(pow(.05/abs(uv.y - 0.02)*1.3, 1.3)*gradient_color);
		COLOR.rgb = max(COLOR.rgb, vec3(pow(.01/abs(uv.x-.02+uv.y*.1)*1.3, 1.3)*(1. - gradient_color)));
	} else {
		COLOR.rgb = vec3(1.);
	}
	if ((COLOR.r + COLOR.g + COLOR.b) < .3) {
		COLOR.rgb = vec3(1.);
	}

	COLOR.a = texture(TEXTURE, UV).a;

	if (texture(TEXTURE, UV - vec2(0.,border)).a < .5) {
		COLOR.rgb = borderColor;
	}
	if (texture(TEXTURE, UV+ vec2(0., border)).a < .5) {
		COLOR.rgb = borderColor;
	}
	if (texture(TEXTURE, UV - vec2(border, 0.)).a < .5) {
		COLOR.rgb = borderColor;
	}
	if (texture(TEXTURE, UV+ vec2(border, 0.)).a < .5) {
		COLOR.rgb = borderColor;
	}

}
