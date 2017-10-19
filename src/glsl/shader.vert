precision mediump float;

attribute vec3 position;
attribute vec3 color;

uniform float time;
uniform mat4 projection;
uniform mat4 view;
uniform mat4 model;

varying vec3 vColor;

mat4 rotationMatrix(vec3 axis, float angle)
{
    axis = normalize(axis);
    float s = sin(angle);
    float c = cos(angle);
    float oc = 1.0 - c;
    
    return mat4(oc * axis.x * axis.x + c,           oc * axis.x * axis.y - axis.z * s,  oc * axis.z * axis.x + axis.y * s,  0.0,
                oc * axis.x * axis.y + axis.z * s,  oc * axis.y * axis.y + c,           oc * axis.y * axis.z - axis.x * s,  0.0,
                oc * axis.z * axis.x - axis.y * s,  oc * axis.y * axis.z + axis.x * s,  oc * axis.z * axis.z + c,           0.0,
                0.0,                                0.0,                                0.0,                                1.0);
}

void main () {
    vColor = color;
    vec4 rpos = vec4( position, 0) * rotationMatrix( vec3(1.0, 1.0, 0.0), time * .25 );
    gl_Position = projection * view * model * vec4( rpos.xyz, 1.0 );
}