shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx;

#define FNL_COMPILER_OPTIMSATIONS_REQUIRED
#define SELECTED_NOISE_TYPE FNL_NOISE_OPENSIMPLEX2S
#define SELECTED_FRACTAL_TYPE FNL_FRACTAL_FBM
#include "res://addons/FastNoiseLiteRuntimeShader/FastNoiseLiteLib.gdshaderinc"

//#region Uniforms
group_uniforms NoiseSettings;
uniform int seed;
uniform float frequency;
uniform int fractal_octaves;
uniform float fractal_lacunarity;
uniform float fractal_gain;
uniform float fractal_weighted_strength;
uniform float delta;
group_uniforms;

group_uniforms TerrainGen;
uniform float u;
uniform float v;
uniform int height;
uniform float shadow_basis = 0.1;
group_uniforms;

//#region Texture Uniforms
group_uniforms Textures;

//#region GrassTexture
group_uniforms Textures.GrassTexture;
uniform sampler2D grass_image_ao;
uniform sampler2D grass_image_colour;
uniform sampler2D grass_image_normal;
uniform sampler2D grass_image_roughness;
//#endregion

//#region SandTexture
group_uniforms Textures.SandTexture;
uniform sampler2D sand_image_ao;
uniform sampler2D sand_image_colour;
uniform sampler2D sand_image_normal;
uniform sampler2D sand_image_roughness;
//#endregion

//#region DirtTexture
group_uniforms Textures.DirtTexture;
uniform sampler2D dirt_image_ao;
uniform sampler2D dirt_image_colour;
uniform sampler2D dirt_image_normal;
uniform sampler2D dirt_image_roughness;
//#endregion

//#region RockTexture
group_uniforms Textures.RockTexture;
uniform sampler2D rock_image_ao;
uniform sampler2D rock_image_colour;
uniform sampler2D rock_image_normal;
uniform sampler2D rock_image_roughness;
//#endregion

//#region SnowTexture
group_uniforms Textures.SnowTexture;
uniform sampler2D snow_image_ao;
uniform sampler2D snow_image_colour;
uniform sampler2D snow_image_normal;
uniform sampler2D snow_image_roughness;
group_uniforms;
//#endregion

//#endregion

uniform mat3 terrain_normal_basis;
//#endregion

varying vec2 world_pos;

void vertex() {
    fnl_state noise = fnlCreateState(seed);
    noise.frequency = frequency / 1000.0;
    noise.fractal_type = SELECTED_FRACTAL_TYPE;
    noise.octaves = fractal_octaves;
    noise.lacunarity = fractal_lacunarity;
    noise.gain = fractal_gain;
    noise.weighted_strength = fractal_weighted_strength;

    vec2 chunk_offset = vec2(u, v) * 1000.0;
    vec2 current_pos = VERTEX.xz + chunk_offset;

	world_pos = current_pos; 

    float noise_value = fnlGetNoise2D(noise, current_pos.x, current_pos.y);
    VERTEX.y += noise_value * float(height);

    // float height_left  = fnlGetNoise2D(noise, current_pos.x - delta, current_pos.y) * float(height);
    // float height_right = fnlGetNoise2D(noise, current_pos.x + delta, current_pos.y) * float(height);
    // float height_down  = fnlGetNoise2D(noise, current_pos.x, current_pos.y - delta) * float(height);
    // float height_up    = fnlGetNoise2D(noise, current_pos.x, current_pos.y + delta) * float(height);

    // vec3 pos_left  = vec3(-delta, height_left,  0.0);
    // vec3 pos_right = vec3(delta,  height_right, 0.0);
    // vec3 pos_down  = vec3(0.0,    height_down,  -delta);
    // vec3 pos_up    = vec3(0.0,    height_up,    delta);

    // vec3 clean_tangent  = pos_right - pos_left;
    // vec3 clean_binormal = pos_up - pos_down;

    // vec3 calculated_normal = cross(clean_binormal, clean_tangent);

    // NORMAL  = normalize(calculated_normal);
    // TANGENT = normalize(clean_tangent);
    // BINORMAL = normalize(clean_binormal);

}

void fragment() {
	//#region Frag Texture Vars
	vec3 grass_texture_ao = texture(grass_image_ao, UV).rgb;
	vec3 grass_texture_colour = texture(grass_image_colour, UV).rgb;
	vec3 grass_texture_normal = texture(grass_image_normal, UV).rgb;
	vec3 grass_texture_roughness = texture(grass_image_roughness, UV).rgb;

	vec3 sand_texture_ao = texture(sand_image_ao, UV).rgb;
	vec3 sand_texture_colour = texture(sand_image_colour, UV).rgb;
	vec3 sand_texture_normal = texture(sand_image_normal, UV).rgb;
	vec3 sand_texture_roughness = texture(sand_image_roughness, UV).rgb;

	vec3 dirt_texture_ao = texture(dirt_image_ao, UV).rgb;
	vec3 dirt_texture_colour = texture(dirt_image_colour, UV).rgb;
	vec3 dirt_texture_normal = texture(dirt_image_normal, UV).rgb;
	vec3 dirt_texture_roughness = texture(dirt_image_roughness, UV).rgb;

	vec3 rock_texture_ao = texture(rock_image_ao, UV).rgb;
	vec3 rock_texture_colour = texture(rock_image_colour, UV).rgb;
	vec3 rock_texture_normal = texture(rock_image_normal, UV).rgb;
	vec3 rock_texture_roughness = texture(rock_image_roughness, UV).rgb;
	
	vec3 snow_texture_ao = texture(snow_image_ao, UV).rgb;
	vec3 snow_texture_colour = texture(snow_image_colour, UV).rgb;
	vec3 snow_texture_normal = texture(snow_image_normal, UV).rgb;
	vec3 snow_texture_roughness = texture(snow_image_roughness, UV).rgb;
	//#endregion

	fnl_state noise = fnlCreateState(seed);
    noise.frequency = frequency / 1000.0;
    noise.fractal_type = SELECTED_FRACTAL_TYPE;
    noise.octaves = fractal_octaves;
    noise.lacunarity = fractal_lacunarity;
    noise.gain = fractal_gain;
    noise.weighted_strength = fractal_weighted_strength;

    float h_left  = fnlGetNoise2D(noise, world_pos.x - delta, world_pos.y) * float(height);
    float h_right = fnlGetNoise2D(noise, world_pos.x + delta, world_pos.y) * float(height);
    float h_down  = fnlGetNoise2D(noise, world_pos.x, world_pos.y - delta) * float(height);
    float h_up    = fnlGetNoise2D(noise, world_pos.x, world_pos.y + delta) * float(height);
    
	float slope_x = (h_left - h_right) * shadow_basis;
    float slope_z = (h_down - h_up) * shadow_basis;

    vec3 pixel_normal = normalize(vec3(slope_x, 2.0 * delta, slope_z));

    vec3 packed_normal = (pixel_normal * 0.5) + 0.5;

    ALBEDO = vec3(1.0);
    NORMAL_MAP = packed_normal;
}