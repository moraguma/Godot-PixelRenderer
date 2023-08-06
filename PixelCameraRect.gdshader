shader_type canvas_item;

uniform vec2 zoom = vec2(1.0, 1.0);
uniform vec2 trueRes = vec2(1920.0, 1080.0);
uniform vec2 aimRes = vec2(320.0, 180.0);
uniform vec2 o = vec2(0.0, 0.0);

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;


void fragment() {
	vec2 res = aimRes / zoom;
	vec2 pixel_uv = round(UV * res + fract(o)) / res;
	
	vec4 text = texture(screen_texture, pixel_uv, 0.0);
	
	COLOR = text;
}