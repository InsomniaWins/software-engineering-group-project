extends Control

onready var _vertical_button_box_node:VerticalButtonBox = $VerticalButtonBox

func _on_VerticalButtonBox_button_pressed(button_box, button_index):
	var button_name = button_box.get_button_name(button_index)
	match button_name:
		"NEW":
			SceneManager.change_scene("res://scenes/intro_dialog/intro_dialog.tscn")
		"QUIT":
			get_tree().quit()
