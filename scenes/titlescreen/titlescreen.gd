extends Control

const INTRO_DIALOG_PATH:String = "res://scenes/intro_dialog/intro_dialog.tscn"
const CREDITS_DIALOG_PATH:String = "res://scenes/credits/credits.tscn"

onready var _vertical_button_box_node:VerticalButtonBox = $VerticalButtonBox

func _on_VerticalButtonBox_button_pressed(button_box, button_index):
	var button_name = button_box.get_button_name(button_index)
	match button_name:
		"NEW":
			SceneManager.change_scene(INTRO_DIALOG_PATH)
		"CONTINUE":
			SaveManager.load_game()
		"QUIT":
			
			get_tree().quit()
		"CREDITS":
			
			SceneManager.change_scene(CREDITS_DIALOG_PATH)

