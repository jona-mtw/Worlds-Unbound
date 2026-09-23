@tool
extends Node3D

@export var collision_size := 200.0

@onready var mesh: MeshInstance3D = $"../Mesh"
@onready var collision: CollisionShape3D = $StaticBody3D/CollisionShape3D

var material: ShaderMaterial

var base_vertices: PackedVector3Array
var mesh_indices: PackedInt32Array
var collision_indices: PackedInt32Array

var terrain_offset := Vector2.ZERO

var noise := FastNoiseLite.new()

var player: CharacterBody3D


func _ready():
	player = $"../../../EntityRoot/Player"

	material = mesh.get_surface_override_material(0) as ShaderMaterial

	var mesh_arrays := mesh.mesh.surface_get_arrays(0)

	base_vertices = mesh_arrays[Mesh.ARRAY_VERTEX]
	mesh_indices = mesh_arrays[Mesh.ARRAY_INDEX]

	build_collision_indices()

	setup_noise()
	update_terrain_offset()
	update_shape()


func _process(_delta):
	update_terrain_offset()


func setup_noise():
	noise.seed = int(material.get_shader_parameter("seed"))

	noise.frequency = float(
		material.get_shader_parameter("frequency")
	) * 1000.0

	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM

	noise.fractal_octaves = int(
		material.get_shader_parameter("fractal_octaves")
	)

	noise.fractal_lacunarity = float(
		material.get_shader_parameter("fractal_lacunarity")
	)

	noise.fractal_gain = float(
		material.get_shader_parameter("fractal_gain")
	)

	noise.fractal_weighted_strength = float(
		material.get_shader_parameter("fractal_weighted_strength")
	)


func update_terrain_offset():
	var shader_u := float(material.get_shader_parameter("u"))
	var shader_v := float(material.get_shader_parameter("v"))

	var new_offset := Vector2(shader_u, shader_v)

	if new_offset != terrain_offset:
		terrain_offset = new_offset
		update_shape()


func update_shape():
	var faces := PackedVector3Array()

	faces.resize(collision_indices.size())

	var terrain_height := int(
		material.get_shader_parameter("height")
	)

	for i in collision_indices.size():
		var vertex_index := collision_indices[i]
		var vertex := base_vertices[vertex_index]

		var height_value := get_height(
			Vector2(vertex.x, vertex.z),
			terrain_height
		)

		faces[i] = Vector3(
			vertex.x,
			height_value,
			vertex.z
		)

	var shape := ConcavePolygonShape3D.new()
	shape.set_faces(faces)

	collision.shape = shape


func get_height(local_pos: Vector2, terrain_height: int) -> float:
	var current_pos := local_pos + terrain_offset * 1000.0

	var noise_value := noise.get_noise_2d(
		current_pos.x,
		current_pos.y
	)

	return noise_value * float(terrain_height)


func build_collision_indices():
	var half_size := collision_size * 0.5

	var selected_indices := PackedInt32Array()

	for i in range(0, mesh_indices.size(), 3):
		var first := base_vertices[mesh_indices[i]]
		var second := base_vertices[mesh_indices[i + 1]]
		var third := base_vertices[mesh_indices[i + 2]]

		var triangle_min := Vector2(
			min(first.x, second.x, third.x),
			min(first.z, second.z, third.z)
		)

		var triangle_max := Vector2(
			max(first.x, second.x, third.x),
			max(first.z, second.z, third.z)
		)

		if triangle_max.x < -half_size:
			continue

		if triangle_min.x > half_size:
			continue

		if triangle_max.y < -half_size:
			continue

		if triangle_min.y > half_size:
			continue

		selected_indices.append(mesh_indices[i])
		selected_indices.append(mesh_indices[i + 1])
		selected_indices.append(mesh_indices[i + 2])

	collision_indices = selected_indices