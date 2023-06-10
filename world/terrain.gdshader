shader_type canvas_item;

uniform bool active = false;
uniform float modul = 1.0; 

void fragment() {
	vec4 previous_color = texture(TEXTURE, UV);
	vec4 transp_color = vec4(previous_color.r, previous_color.g, previous_color.b, previous_color.a*modul);
	vec4 new_color = previous_color;
	new_color.a = transp_color.a; 
	if (active) {
		new_color.a = transp_color.a*(1.0-UV.y);
	}
	COLOR = new_color;
}