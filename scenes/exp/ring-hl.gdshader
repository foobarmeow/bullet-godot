shader_type canvas_item;
render_mode blend_add;
uniform float slice_start : hint_range(0, 100) = 0.0;
uniform float slice_end : hint_range(0, 100) = 0.0;

void vertex() {
    // Transform the vertex position as needed
}

void fragment() {
     // Check if the current pixel is within the specified slice range
    if (UV.y >= slice_start/100.0 && UV.y <= slice_end/100.0) {
        // Adjust the intensity of the slice by increasing the red channel
        COLOR.a = 0.0; // You can modify this value based on your preference
    }
 }