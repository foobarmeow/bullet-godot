shader_type canvas_item;
render_mode blend_add;
uniform float circle_radius : hint_range(0, 1) = 0.5;
uniform float highlight_width : hint_range(0, 1) = 0.1;
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

    // Check if the distance is within the specified range
    if (abs(distance_to_center - circle_radius) <= highlight_width / 2.0) {
        // Check if the angle is within the specified segment
        if (angle >= start_angle && angle <= end_angle) {
            // Adjust the intensity of the highlighted area
            COLOR.r = 255.0; // You can modify this value based on your preference
        	COLOR.g = 255.0;
			COLOR.b = 0.0;
			COLOR.a = 1.25;
		}
    }
}
