shader_type spatial;
render_mode world_vertex_coords, specular_disabled, vertex_lighting, shadows_disabled;

global uniform vec2 resolution;
uniform sampler2D color_texture: source_color, filter_nearest;
uniform float vertex_wobble: hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float affine_mapping: hint_range(0.0, 1.0, 0.01) = 0.5;
varying vec2 original_uv;

uniform float z_clip_scale: hint_range(0.0, 1.0, 0.01) = 0.6;
uniform float alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

// 4x4 Bayer matrix for screen-door transparency
const mat4 bayer_matrix = mat4(
	vec4(0.0, 8.0, 2.0, 10.0),
	vec4(12.0, 4.0, 14.0, 6.0),
	vec4(3.0, 11.0, 1.0, 9.0),
	vec4(15.0, 7.0, 13.0, 9.0)
) / 16.0;

void vertex() {
	vec4 position = PROJECTION_MATRIX * VIEW_MATRIX * vec4(VERTEX, 1.0);
	vec2 snapping = resolution * vertex_wobble;
	vec2 screen_position = round(position.xy * snapping) / snapping;
	POSITION = vec4(screen_position, mix(position.w, position.z, z_clip_scale), position.w);
		
	original_uv = UV;
	UV *= (VIEW_MATRIX * vec4(VERTEX, 1.0)).z;
}

void fragment() {
	vec2 uv = mix(original_uv, UV / VERTEX.z, affine_mapping);
	vec4 tex_color = texture(color_texture, uv);
	
	ivec2 pixel_coord = ivec2(FRAGCOORD.xy);
	float dither_threshold = bayer_matrix[pixel_coord.x % 4][pixel_coord.y % 4];
	
	if ((tex_color.a * alpha) < dither_threshold) {
		discard;
	}
	
	ALBEDO = tex_color.rgb;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
