@tool
extends Node
@onready var terrain: MeshInstance3D = $"World/LevelRoot/Terrain/Mesh"

var image: Image

func create_heightmap(size: int, normal: bool = false) -> NoiseTexture2D:
	var noise := FastNoiseLite.new()

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.frequency = 0.0015
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.fractal_octaves = 5
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	noise.fractal_weighted_strength = 0.7

	var noise_texture := NoiseTexture2D.new()

	noise_texture.noise = noise.duplicate()
	noise_texture.width = size
	noise_texture.height = size
	noise_texture.seamless = true
	noise_texture.seamless_blend_skirt = 0.1
	noise_texture.as_normal_map = normal

	return noise_texture

func _ready() -> void:
	var material := terrain.get_surface_override_material(0)

	var heightmap_texture = create_heightmap(1000, false)
	material.set_shader_parameter(
		"heightmap", heightmap_texture
	)

	var normalmap_texture = create_heightmap(1000, true)
	material.set_shader_parameter(
		"normalmap", normalmap_texture
	)
