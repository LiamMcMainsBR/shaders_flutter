uniform vec2 u_resolution;  

vec4 circle(vec2 center, float radius) {
    // Normalizes the x and y coordinate
    vec2 normalizedCoord = gl_FragCoord.xy / u_resolution;
    
    // Gets the distance between the normalized coord and
    // the center of the circle
    float dist = distance(normalizedCoord, vec2(center));
    
    // If the distance is greater than the circle radius, white color
    // If the distance is less than the circle radius, black color
	vec4 color = step(radius, vec4(dist));

    // Invert it so the white is on the inside and black is on the outside
    return abs(color - 1.0);
}

void main() {
	gl_FragColor = circle(vec2(0.5, 0.5), 0.3);
}