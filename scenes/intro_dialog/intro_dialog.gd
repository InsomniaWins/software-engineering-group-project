extends Control

const _CHARACTER_TIMER_INTERVAL:float = 0.1

var _character_timer:float = 0.0
var _typing_effect_active:bool = false

onready var _label_node = $RichTextLabel
onready var _text_display_timer = $TextDisplayTimer

var _current_text_index:int = 0
var _text_array:Array = [
	"[center]Long ago, there was a strong wizard.",
	"[center]This is VERY\nVERY centered!"
]

func _ready():
	_show_text(_text_array[_current_text_index])


func _unhandled_input(event):
	if event.is_action_pressed("select"):
		get_tree().set_input_as_handled()
		_go_to_titlescreen()


func _process(delta):
	
	# typing effect
	if _typing_effect_active:
		if _label_node.visible_characters < _label_node.text.length():
			_character_timer -= delta
			
			while _character_timer < 0.0:
				var finished_showing_text:bool = _show_character()
				
				if finished_showing_text:
					_character_timer = _CHARACTER_TIMER_INTERVAL
					_typing_effect_active = false
					
					_text_display_timer.start()
					
					break
				else:
					_character_timer += _CHARACTER_TIMER_INTERVAL


func _go_to_titlescreen():
	SceneManager.change_scene("res://scenes/titlescreen/titlescreen.tscn")


func _show_text(text:String):
	_label_node.visible_characters = 0
	_typing_effect_active = true
	_label_node.bbcode_text = text


# returns true if text finished typing
func _show_character() -> bool:
	_label_node.visible_characters += 1
	if _label_node.visible_characters == _label_node.text.length():
		_character_timer = _CHARACTER_TIMER_INTERVAL
		return true
	return false

# after 1 second, display next text
# if there is no more text to display, go to titlescreen
func _on_TextDisplayTimer_timeout():
	_current_text_index += 1
	
	if _current_text_index < _text_array.size():
		_show_text(_text_array[_current_text_index])
	else:
		_go_to_titlescreen()
