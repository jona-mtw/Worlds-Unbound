extends Control

@onready var settings_menu: Control = $"../../SettingsLayer/SettingsMenu"
@onready var pause_column: Control = $PauseColumn

func _ready() -> void:
	await get_tree().process_frame
	escape_key_pressed()
	EventListener.escape_key_pressed.connect(escape_key_pressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("exit"):
		get_tree().quit()

func escape_key_pressed() -> void:
	if settings_menu.visible:
		UiManager.hide_settings_menu()
	else:
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused

		if get_tree().paused:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_resume_button_pressed() -> void:
	escape_key_pressed()

func _on_settings_button_pressed() -> void:
	UiManager.show_settings_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_main_menu_button_pressed() -> void:
	UiManager.switch_main_menu()
