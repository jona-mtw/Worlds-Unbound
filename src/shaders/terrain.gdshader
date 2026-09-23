shader_type spatial;
render_mode blend_mix, depth_draw_opaque, depth_test_default, cull_back, diffuse_lambert, specular_schlick_ggx;

//#region Uniforms
group_uniforms TerrainGen;
uniform float u;
uniform float v;
uniform sampler2D heightmap;
uniform int height;
uniform sampler2D normalmap;
uniform vec4 colour : source_color;
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

vec3 unpack_normalmap(vec4 rgba){
	vec3 n = rgba.xzy * 2.0 - vec3(1.0);
	n.z *= 1.0;
	return n;
}

void vertex() {
	float heightmap_u = vec3(UV, 0.0).x + u;
	float heightmap_v = vec3(UV, 0.0).y + v;

	vec3 heightmap_texture = texture(heightmap, vec2(heightmap_u, heightmap_v)).rgb;
	vec3 vertex_offset = vec3(heightmap_texture.xyz) * vec3(0.0, float(height), 0.0);

	VERTEX += vertex_offset;
	NORMAL = terrain_normal_basis * unpack_normalmap(texture(normalmap, vec2(heightmap_u, heightmap_v)));
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
}
