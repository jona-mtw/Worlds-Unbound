extends MeshInstance3D

@onready var player: CharacterBody3D = $"../../../EntityRoot/Player"
var snap_step := 20
var player_pos: Vector3
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.connect("timeout", Callable(self, "snap"))
	timer.set_wait_time(0.25)
	snap()

func snap() -> void:
	var div := 20_000
	player_pos = player.global_transform.origin.snapped(Vector3(snap_step, 0, snap_step))
	global_transform.origin.x = player_pos.x
	global_transform.origin.z = player_pos.z
	get_surface_override_material(0).set_shader_parameter("u", player_pos.x / div)
	get_surface_override_material(0).set_shader_parameter("v", player_pos.z / div)
	timer.start()
