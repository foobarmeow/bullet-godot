shader_type canvas_item;
render_mode blend_add;

uniform vec4 highlight_color : source_color = vec4(1.0, 1.0, 0.0, 1.0);
uniform float circle_radius : hint_range(0, 1) = 0.5;
uniform float highlight_width : hint_range(0, 1) = 0.1;
uniform float feather_width : hint_range(0,2) = 0.05; // Adjust this for feathering
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
    float angle = atan(UV.x - center.x, UV.y - center.y);

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
            // Calculate the distance-based blending factor for the edges
            float edge_blend = smoothstep(0.0, feather_width, abs(distance_to_center - circle_radius - highlight_width / 2.0));

            // Check if it's near the edges, then apply blending
            if (edge_blend > 0.0 && edge_blend < 1.0) {
                // Interpolate between the original color and the highlight color
                COLOR = vec4(mix(texture(TEXTURE, UV).rgb, highlight_color.rgb, edge_blend), 1.0);
            }
        }
    }

    // Use the original color if not in the highlighted area
}
