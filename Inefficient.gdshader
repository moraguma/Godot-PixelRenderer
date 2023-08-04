shader_type canvas_item;

uniform vec2 zoom = vec2(1.0, 1.0);
uniform vec2 trueRes = vec2(1920.0, 1080.0);
uniform vec2 aimRes = vec2(16.0, 9.0);
uniform vec2 o = vec2(0.0, 0.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

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
	vec2 pixel_uv = floor(UV * res + fract(o)) / res;
	
	vec4 colors[16];
	int occurences[16];
	int pos = 0;
	for (float i = 0.0; i < trueRes[0] / aimRes[0]; i++) {
		for (float j = 0.0; j < trueRes[1] / aimRes[1]; j++) {
			vec4 c = textureLod(screen_texture, pixel_uv, 0.0);
			
			if (pos < 16) {
				int c_pos = find(c, colors, pos);
				if (c_pos == -1) {
					colors[pos] = c;
					c_pos = pos;
					pos++;
				}
				
				occurences[c_pos]++;
			}
		}
	}
	
	int m = 0;
	vec4 c;
	for (int i = 0; i < pos; i++) {
		if (occurences[i] > m) {
			c = colors[i];
			m = occurences[i];
		}
	}
	
	COLOR = c;
}
