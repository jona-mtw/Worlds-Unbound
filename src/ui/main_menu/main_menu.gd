extends Control

func _ready() -> void:
	$SettingsMenu.hide()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_settings_button_pressed() -> void:
	$SettingsMenu.show()
	$MainMenuColumn.hide()

func _on_play_button_pressed() -> void:
	UiManager.start_main_game()