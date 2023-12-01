shader_type canvas_item;
render_mode blend_add;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float circle_radius : hint_range(0, 1) = 0.5;
uniform float ring_width : hint_range(0, 1) = 0.1; // Adjust this for the width of the ring

void vertex() {
    // Transform the vertex position as needed
}

void fragment() {
    // Calculate the distance from the current pixel to the center of the circle
    vec2 center = vec2(0.5, 0.5);
    float distance_to_center = distance(UV, center);

    // Check if the distance is within the specified range for the ring
    if (abs(distance_to_center - circle_radius) <= ring_width / 2.0) {
        // Set the color to the highlight color
        COLOR = highlight_color;
    } else {
		COLOR.a = 0.0;
	}
	
}
