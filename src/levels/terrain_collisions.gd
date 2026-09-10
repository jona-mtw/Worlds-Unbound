extends Node3D

#region vars
@onready var terrain: MeshInstance3D = $"../Mesh"
@onready var terrain_heightmap: NoiseTexture2D = terrain.get_surface_override_material(0).get_shader_parameter("heightmap")
@onready var img: Image = terrain_heightmap.get_image()

@onready var collision: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var collision_shape: HeightMapShape3D = collision.shape
@onready var collision_heightmap: PackedFloat32Array = collision_shape.get_map_data()
@onready var collision_width: int = collision_shape.get_map_width()
@onready var collision_depth: int = collision_shape.get_map_depth()

@onready var player: CharacterBody3D = $"../../../EntityRoot/Player"

@onready var height: int = terrain.get_surface_override_material(0).get_shader_parameter("height")
#endregion

func _ready() -> void:
func _process(_delta: float) -> void:
	update_collisions()

func update_collisions():
	var collision_array := PackedFloat32Array()
	collision_array.resize(collision_heightmap.size())
	var u: float = terrain.get_surface_override_material(0).get_shader_parameter("u")
	var v: float = terrain.get_surface_override_material(0).get_shader_parameter("v")
	collision.global_position.x = player.global_position.x
	collision.global_position.z = player.global_position.z

	var starting_point := Vector2(
		collision.global_position.x - collision_width / 2.0,
		collision.global_position.y - collision_depth / 2.0
	)

	for x in collision_width:
		for y in collision_depth:
			if img:
				var pixel_x: int = fmod(img.get_width(), starting_point.x + u)
				var pixel_y: int = fmod(img.get_height(), starting_point.y + v)

				var vert_height = img.get_pixel(pixel_x, pixel_y)

				collision_array[x + y * collision_width] = vert_height * height

	collision_shape.set_map_data(collision_array)