shader_type canvas_item;

uniform sampler2D screenTexture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float blur: hint_range(0.0, 2.5); //Setting values for blurring screen
uniform float brightness: hint_range(0.0, 1.0); //Sets brightness for brightness

void fragment() {
	COLOR = textureLod(screenTexture, SCREEN_UV, blur);
	COLOR.rgb *= brightness;
}
