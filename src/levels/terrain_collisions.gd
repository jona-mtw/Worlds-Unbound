@tool
extends Node3D

@export var collision_size := 200.0


@onready var mesh: MeshInstance3D = $"../Mesh"
@onready var material := mesh.get_surface_override_material(0) as ShaderMaterial
var heightmap_tex: NoiseTexture2D
var heightmap_img: Image
var img_width: int
var img_depth: int
var height: float
var terrain_offset := Vector2.ZERO
var base_vertices: PackedVector3Array
var base_uvs: PackedVector2Array
var mesh_indices: PackedInt32Array
var collision_indices: PackedInt32Array
var player: CharacterBody3D


@onready var collision: CollisionShape3D = $StaticBody3D/CollisionShape3D

func _ready():
	player = $"../../../EntityRoot/Player"
	while material.get_shader_parameter("heightmap") == null:
		await get_tree().process_frame
	heightmap_tex = material.get_shader_parameter("heightmap") as NoiseTexture2D
	while heightmap_tex.get_image() == null:
		await get_tree().process_frame
	heightmap_img = heightmap_tex.get_image()
	img_width = heightmap_img.get_width()
	img_depth = heightmap_img.get_height()
	height = float(material.get_shader_parameter("height"))

	var mesh_arrays := mesh.mesh.surface_get_arrays(0)
	base_vertices = mesh_arrays[Mesh.ARRAY_VERTEX]
	base_uvs = mesh_arrays[Mesh.ARRAY_TEX_UV]
	mesh_indices = mesh_arrays[Mesh.ARRAY_INDEX]

	build_collision_indices()
	update_shape()
	update_terrain_offset()

func _process(delta: float) -> void:
	var terrain_position := Vector3(mesh.global_position.x, 0.0, mesh.global_position.z)
	if collision.global_position != terrain_position:
		collision.global_position = terrain_position
	update_terrain_offset()

func update_terrain_offset() -> void:
	var shader_u := float(material.get_shader_parameter("u"))
	var shader_v := float(material.get_shader_parameter("v"))
	var next_offset := Vector2(shader_u, shader_v)
	if next_offset != terrain_offset:
		terrain_offset = next_offset
		update_shape()

func update_shape():
	var next_faces := PackedVector3Array()
	next_faces.resize(collision_indices.size())
	for i in collision_indices.size():
		var vertex_index := collision_indices[i]
		var vertex := base_vertices[vertex_index]
		next_faces[i] = Vector3(vertex.x, get_height(base_uvs[vertex_index]), vertex.z)
	var next_shape := ConcavePolygonShape3D.new()
	next_shape.set_faces(next_faces)
	collision.shape = next_shape

func build_collision_indices() -> void:
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
		if triangle_max.x < -half_size or triangle_min.x > half_size:
			continue
		if triangle_max.y < -half_size or triangle_min.y > half_size:
			continue
		selected_indices.append(mesh_indices[i])
		selected_indices.append(mesh_indices[i + 1])
		selected_indices.append(mesh_indices[i + 2])
	collision_indices = selected_indices

func get_height(uv: Vector2) -> float:
	var height_uv := uv + terrain_offset
	height_uv.x = fposmod(height_uv.x, 1.0)
	height_uv.y = fposmod(height_uv.y, 1.0)
	var image_x := height_uv.x * img_width - 0.5
	var image_y := height_uv.y * img_depth - 0.5
	var x0 := floori(image_x)
	var y0 := floori(image_y)
	var x1 := x0 + 1
	var y1 := y0 + 1
	var x_blend := image_x - x0
	var y_blend := image_y - y0
	var top: float = lerp(get_pixel_height(x0, y0), get_pixel_height(x1, y0), x_blend)
	var bottom: float = lerp(get_pixel_height(x0, y1), get_pixel_height(x1, y1), x_blend)
	return lerp(top, bottom, y_blend) * height

func get_pixel_height(x: int, y: int) -> float:
	return heightmap_img.get_pixel(posmod(x, img_width), posmod(y, img_depth)).g
