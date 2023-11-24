shader_type canvas_item;
render_mode skip_vertex_transform;
uniform vec2 player_position = vec2(0, 0);

void vertex() {
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	vec2 v = VERTEX;
	vec2 p = player_position;
	vec2 u = vec2(p.y-v.y, p.x-v.x);
	float m = length(u);
	COLOR = texture(TEXTURE, UV);

	if (m < 1000.0) {
		COLOR.a = 255.0;
	} else {
		COLOR.a = 0.0;
	}
}
