extends Node3D

@onready var terrain: MeshInstance3D = $"../Mesh"
@onready var terrain_heightmap: Texture = terrain.get_surface_override_material(0).get_shader_parameter("heightmap")

@onready var collision: CollisionShape3D = $StaticBody3D/CollisionShape3D
@onready var collision_shape: Shape3D = collision.shape
@onready var collision_heightmap: PackedFloat32Array = collision_shape.get_map_data()

@onready var player: CharacterBody3D = $"../../../EntityRoot/Player"

var collision_arrray := PackedFloat32Array()

func _process(_delta: float) -> void:
	update_collisions()
	
func update_collisions():
	collision.position.x = player.position.x
	collision.position.z = player.position.z
