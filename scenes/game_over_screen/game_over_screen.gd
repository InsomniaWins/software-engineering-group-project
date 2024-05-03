extends Control



func _on_VerticalButtonBox_button_pressed(button_box, button_index):
	match button_box._button_names[button_index]:
		"Retry":
			SaveManager.load_game()
		"Quit":
			SceneManager.change_scene("res://scenes/titlescreen/titlescreen.tscn")
