shader_type spatial;

uniform sampler2D noise;
instance uniform float y;
instance uniform float x;
instance uniform float density;
instance uniform float flick;

float n21(vec2 n, float seed) {
	// return texture(noise, n).r;
    return fract(sin(dot(n, vec2(12.9898 + floor(seed+y), 14.1414 + y))) * 43758.5453);
}

float distanceFromSegment(vec2 U, vec2 A, vec2 B)
{
	vec2 UA = U - A;
    vec2 BA = (B - A);

    float s = dot(UA, BA) / length(BA);   // scalar projection of U-A on B-A
    s = s / length(BA); 				  // normalize the projection value in the range [0,1],
    								      //  a value of 0 means the projection correspond to A, 1 to B,
    									  //  in between the projection is inside the segment,
                                          //  outside [0,1] the projection is outside the segment.
    s = clamp(s, 0., 1.);                 // If the scalar projection is outside [0,1], its value is clamped to
                                          //  0 or 1 ...

    return length(UA - s*BA);          	  // ... so here we compute the distance of U from its projection if it is
                                          // inside the segment, or from the extreme points A or B if it is outside
}

void fragment() {
	vec2 uv = UV;
	vec3 color = vec3(.1, .3, .9);

	float speed = TIME*1.+sin(TIME +cos(TIME+y)-y)*flick;
	float n = texture(noise, uv/2. + vec2(TIME*.1, TIME-texture(noise, uv/20.).r )).r - .5;
	float mag = sin(uv.x*PI)*.05;

	vec2 cells = vec2(density, 1.);
    uv *= cells;

	vec2 id = floor(uv);
    uv = fract(uv);

	float an = min(0.4, n21(vec2(id.y, 2.), TIME) + .2);

    float y1 = n21(vec2(id.x + 100., id.y + floor(speed)), TIME)*an + (1. - an);
    float y2 = n21(vec2(id.x + 1. + 100., id.y + floor(speed)), TIME)*an + (1. - an);

	float d = distanceFromSegment(uv + vec2(0., .5- n*(.2 + .2*abs(sin(TIME*10. + cos(uv.y))))), vec2(0., y1), vec2(1., y2));
    float line = pow(mag/d, 1.2);

	vec3 col = line * max(vec3(0.3, 0.6, 0.3), vec3(sin(TIME + id.y), cos(TIME-id.y*3.), cos(TIME/2. + id.y/2.)));

	EMISSION = col * 3.;
	ALPHA = smoothstep(0.1, 1., (col.b + col.r + col.g)/3.);
}
