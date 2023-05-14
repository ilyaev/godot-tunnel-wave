shader_type canvas_item;

const float border = 0.005;
const vec3 borderColor = vec3(.2, .6, .2);
const vec3 fontColor = vec3(.1, .3, .8);

void fragment() {
	vec2 uv = SCREEN_UV;
	// Place fragment code here.
	// COLOR = vec4(pow(.05/abs(uv.y - 0.02)*1.3, 1.3)*fontColor, 1.);
	// COLOR.rgb = vec3(1., 0., 0.)*step(.5, uv.x);

	COLOR.rgb = vec3(1.);
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
