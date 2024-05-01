extends Control


var text:String = ""
var selected:bool = false


onready var _label_node:Label = $Label
onready var _selection_icon_node:TextureRect = _label_node.get_node("SelectionIcon")


func set_selected(value:bool):
	selected = value
	_selection_icon_node.visible = value


func set_text(new_text:String):
	text = new_text
	_label_node.text = text
