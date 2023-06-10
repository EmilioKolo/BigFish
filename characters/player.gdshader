shader_type canvas_item;

uniform bool active = false;
uniform float modul = 1.0; 

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 white_color = vec4(1.0, 1.0, 1.0, previous_color.a*modul);
	vec4 new_color = previous_color;
	new_color.a = new_color.a*modul; 
	if (active) {
		new_color = white_color;
	}
	COLOR = new_color;
}