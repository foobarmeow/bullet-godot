shader_type canvas_item;
render_mode blend_add;
//render_mode skip_vertex_transform;

uniform bool enabled;
uniform float fade_distance;
uniform vec2 player_position = vec2(0, 0);

varying vec2 world_vertex;

void vertex() {
	//world_vertex = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	world_vertex = VERTEX;
}

void fragment() {
	// Calculate the distance between the fragment and the character
	float chardistance = length(player_position - world_vertex);
	    
	if (enabled) {
		// Calculate the alpha value based on the distance
		float alpha = 1.0 - smoothstep(0.0, fade_distance, chardistance);
		COLOR.a = alpha;
		// Discard the fragment if the alpha is zero
		if (alpha <= 0.0) {
			discard;
		}
	}
}
