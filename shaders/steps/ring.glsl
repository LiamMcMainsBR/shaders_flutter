uniform vec2 u_resolution;

vec4 ring(float radius, float thickness) {
    // Normalizes the x and y coordinate
    vec2 normalizedCoord = gl_FragCoord.xy / u_resolution;
    
    // Get the distance from the center of the shader to the normalized coordinate
    float pct = distance(normalizedCoord, vec2(0.5, 0.5));
    
    // Get the color outside of the inner radius of the ring
    float outsideRingColor = step(radius, pct);
    // Get the color inside the outer radius of the ring
    float insideRingColor = step(1.0 - thickness - radius, abs(1. - pct));
    
    // AND the two together to get just the inside of the ring
    float ringColor = outsideRingColor * insideRingColor;
    
    return vec4(ringColor);
}

void main() {
	gl_FragColor = ring(0.3, 0.1);
}