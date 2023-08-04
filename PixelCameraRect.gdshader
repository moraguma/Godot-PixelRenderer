shader_type canvas_item;

uniform vec2 zoom = vec2(1.0, 1.0);
uniform vec2 trueRes = vec2(1920.0, 1080.0);
uniform vec2 aimRes = vec2(16.0, 9.0);
uniform vec2 o = vec2(0.0, 0.0);

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

int find(vec4 c, vec4 cs[16], int p) {
	for (int i = 0; i < p; i++) {
		if (c == cs[i]) {
			return i;
		}
	}
	return -1;
}

void fragment() {
	vec2 res = aimRes / zoom;
	vec2 pixel = floor(o + UV * res); // To UV
	
	vec4 colors[16];
	int occurences[16];
	int pos = 0;
	for (int i = pixel[0] )
	
	vec4 p = texture(SCREEN_TEXTURE, SCREEN_UV);
	
	COLOR = vec4(zoom, 1.0, 1.0);
}
