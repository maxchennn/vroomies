#version 300 es
precision mediump float;

in vec2 v_texcoord;
out vec4 fragColor;

uniform sampler2D tex;

void main() {
    vec4 color = texture(tex, v_texcoord);

    float scanline = sin(v_texcoord.y * 1200.0) * 0.04;
    color.rgb -= scanline;

    color.r *= 1.02;
    color.g *= 1.05;

    fragColor = color;
}
