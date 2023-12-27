shader_type canvas_item;

uniform vec2 shadowLocation = vec2(0.0, 0.0);		// Location of base of shadow node
uniform vec2 lightLocation = vec2(0.0, 0.0);		// Location of light2D node
uniform float lightWidth = 32.0;					// Width of light texture
uniform float lightHeight = 16.0;					// Height of light texture
uniform float lightStrength = 1.0;					// Strength (energy) of light
uniform float spriteHeight = 20.0;					// Height of shadow sprite. Used to offset skewVector

void vertex() {
	vec2 skewVector = vec2(lightLocation.x - shadowLocation.x, (lightLocation.y - shadowLocation.y) * 0.5 - spriteHeight);	// y *= 0.5 FOR MORE TOP DOWN PERSPECTIVE
	float skewVertex = float(VERTEX.y < 0.0);		// ONLY MOVE THE TOP 2 (y < 0) VERTICIES TO ACHEIVE A SKEW
	
	float skewedX = VERTEX.x - (skewVector.x * skewVertex);
	float skewedY = VERTEX.y - (skewVector.y * skewVertex);
	
	VERTEX = vec2(skewedX, skewedY);
}

void fragment() {
	vec4 mask = texture(TEXTURE, UV);
	float distX = lightLocation.x - VERTEX.x;
	float distY = lightLocation.y - VERTEX.y;
	float perc = 1.0 - distance(vec2(distX / lightWidth, 0.0), vec2(0.0, distY / lightHeight));
	float alpha = perc * lightStrength;
	COLOR =  mask * vec4(1.0, 0.0, 0.0, 1.0) * vec4(alpha);
}