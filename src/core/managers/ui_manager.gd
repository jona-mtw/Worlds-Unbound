extends Node

var pause_menu
var settings_menu

var main_menu_column
var main_menu_settings_menu

func _ready() -> void:
	main_menu_column = $"../MainMenu/MainMenuColumn"
	main_menu_settings_menu = $"../MainMenu/SettingsMenu"

func start_main_game():
	get_tree().change_scene_to_file("res://src/core/main_game/main_game.tscn")
	await get_tree().scene_changed
	await get_tree().process_frame
	pause_menu = $"../MainGame/UI/PauseLayer/PauseMenu"
	settings_menu = $"../MainGame/UI/SettingsLayer/SettingsMenu"

func switch_main_menu():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://src/ui/main_menu/main_menu.tscn")
	await get_tree().scene_changed
	await get_tree().process_frame
	main_menu_column = $"../MainMenu/MainMenuColumn"
	main_menu_settings_menu = $"../MainMenu/SettingsMenu"

func show_settings_menu():
	pause_menu.hide()
	settings_menu.show()

func hide_settings_menu():
	if get_tree().current_scene.name == "MainMenu":
		main_menu_column.show()
		main_menu_settings_menu.hide()
		return
	settings_menu.hide()
	pause_menu.show()
