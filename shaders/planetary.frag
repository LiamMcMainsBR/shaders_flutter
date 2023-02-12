#include <flutter/runtime_effect.glsl>

out vec4 fragColor;
layout(location = 0) uniform float u_time;

vec2 u_resolution = vec2(343.0,343.0);

#define PI 3.14159265359

vec3 circle(vec2 center, float radius, vec2 normalizedPoint) {
    float pct = distance(normalizedPoint, vec2(center));
    
	vec3 color = step(radius, vec3(pct));

    return abs(color - 1.0);
}

mat2 rotate2d(float _angle) {
    return mat2(cos(_angle),-sin(_angle),
                sin(_angle),cos(_angle));
}

vec3 ring(float radius, float thickness) {
    vec2 normalizedPoint = FlutterFragCoord() / u_resolution;
    
        float pct = distance(normalizedPoint, vec2(0.5, 0.5));
    
    float isOnLine = step(radius, pct) * step(1.0 - thickness - radius, abs(1. - pct));
    
    return vec3(isOnLine);
}

void main(void) {
    // Keep a reference to the original normalized coordinate space 
    // so we can use it for the stationary circles
    vec2 originalPoint = FlutterFragCoord() / u_resolution;

    // Normalize the coordinate space
    vec2 normalizedPoint = FlutterFragCoord() / u_resolution;

    // Rotate the coordinate space
    normalizedPoint -= vec2(0.5);
    normalizedPoint = rotate2d( u_time * 0.15 * PI ) * normalizedPoint;
    normalizedPoint += vec2(0.5);
    
    // Add the rings
    fragColor = vec4(ring(0.25, 0.005), 1.0);
    fragColor += vec4(ring(0.35, 0.003), 1.0);
    fragColor += vec4(ring(0.45, 0.001), 1.0);

    // Add the circles on the rings
    vec3 firstCircle = circle(vec2(0.610,0.727), 0.01, normalizedPoint);
    fragColor += vec4(vec3(firstCircle), 1.0);

    vec3 secondCircle = circle(vec2(0.5,0.248), 0.01, normalizedPoint);
    fragColor += vec4(vec3(secondCircle), 1.0);

    vec3 thirdCircle = circle(vec2(0.920,0.336), 0.005, normalizedPoint);
    fragColor += vec4(vec3(thirdCircle), 1.0);

    vec3 fourthCircle = circle(vec2(0.3,0.21), 0.005, normalizedPoint);
    fragColor += vec4(vec3(fourthCircle), 1.0);

    vec3 fifthCircle = circle(vec2(0.158,0.21), 0.012, normalizedPoint);
    fragColor += vec4(vec3(fifthCircle), 1.0);

    vec3 sixthCircle = circle(vec2(0.248,0.5), 0.006, normalizedPoint);
    fragColor += vec4(vec3(sixthCircle), 1.0);

    // Add the stationary, pulsing circles
    vec3 seventhCircle = circle(vec2(0.32,0.54), 0.006 + abs(sin(u_time)) / 125.0, originalPoint);
    fragColor += vec4(vec3(seventhCircle), 1.0);

    vec3 circle8 = circle(vec2(0.68,0.12), 0.002 + abs(sin(u_time + 0.5)) / 180.0, originalPoint);
    fragColor += vec4(vec3(circle8), 1.0);

    vec3 circle9 = circle(vec2(0.6,0.9), 0.002 + abs(sin(u_time + 0.5)) / 180.0, originalPoint);
    fragColor += vec4(vec3(circle9), 1.0);

    // Filter out the black color
    fragColor = vec4(fragColor.xyz, step(0.5, fragColor.x));
}