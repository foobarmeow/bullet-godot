shader_type canvas_item;
render_mode blend_add;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float circle_radius : hint_range(0, 1) = 0.5;
uniform float segment_width : hint_range(0, 1) = 0.1;
uniform float start_angle : hint_range(0, 360) = 0.0;
uniform float end_angle : hint_range(0, 360) = 180.0;

void vertex() {
    // Transform the vertex position as needed
}

void fragment() {
    // Calculate the distance from the current pixel to the center of the circle
    vec2 center = vec2(0.5, 0.5);
    float distance_to_center = distance(UV, center);

    // Calculate the angle of the current pixel in radians using atan
    float angle = atan(UV.y - center.y, UV.x - center.x);

    // Convert the angle to degrees
    angle = degrees(angle);

    // Ensure the angle is positive
    if (angle < 0.0) {
        angle += 360.0;
    }

    // Check if the distance is within the specified range and angle is within the segment
    if (distance_to_center >= circle_radius - 0.5 * segment_width &&
        distance_to_center <= circle_radius + 0.5 * segment_width &&
        angle >= start_angle && angle <= end_angle) {
        // Set the color to the highlight color
        COLOR = highlight_color;
    } else {
		COLOR.a = 0.0;
	}
}
