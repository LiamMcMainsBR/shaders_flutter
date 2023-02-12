#define PI 3.141592654

uniform float u_time;
uniform vec2 u_resolution;

// Create a 2x2 rotation matrix given a specific angle
mat2 rotate2d(float _angle) {
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

void main() {
    vec2 normalizedCoord = gl_FragCoord.xy / u_resolution.xy;
    
    // Move the normalized coordinate over so the domain and range are (-0.5, 0.5) instead of (0, 1)
    normalizedCoord -= vec2(0.5);
    // Rotate the coordinate space proportional to u_time
    normalizedCoord = rotate2d( u_time * PI ) * st;
    // Move the normalized coordinate back to the (0, 1) domain and range
    normalizedCoord += vec2(0.5);
    
	gl_FragColor = vec4(normalizedCoord.x, normalizedCoord.y, 1.0, 1.0);
}