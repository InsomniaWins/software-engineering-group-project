extends Control
class_name VerticalButtonBox

signal button_pressed(button_box, button_index)
signal button_selected(button_box, button_index)
signal button_deselected(button_box, button_index)

const VerticalButtonLabel = preload("res://scenes/vertical_button_label/vertical_button_label.tscn")

export var _button_names:Array = []

var _selected_button:int = 0

onready var _button_vbox_container_node = $Buttons
onready var _move_sound_player_node = $MoveSound

func _ready():
	_update_labels()
	select_button(0)

func _physics_process(delta):
	rect_size = $Buttons.rect_size

func _unhandled_input(event):
	if event.is_action_pressed("up"):
		get_tree().set_input_as_handled()
		_move_up()
		
	elif event.is_action_pressed("down"):
		get_tree().set_input_as_handled()
		_move_down()
		
	elif event.is_action_pressed("select"):
		get_tree().set_input_as_handled()
		_press()


func set_buttons(button_names:Array):
	_button_names = button_names
	_update_labels()


func remove_button(button_index:int):
	_button_names.remove(button_index)
	_update_labels()


func add_button(button_name:String):
	_button_names.append(button_name)
	_update_labels()


func _update_labels():
	
	var button_count = _button_names.size()
	
	while _button_vbox_container_node.get_child_count() < button_count:
		var button_label:Control = VerticalButtonLabel.instance()
		_button_vbox_container_node.add_child(button_label)
	
	while _button_vbox_container_node.get_child_count() > button_count:
		var button_label = _button_vbox_container_node.get_child(0)
		
		_button_vbox_container_node.remove_child(button_label)
		button_label.queue_free()
	
	for i in button_count:
		var button_text = _button_names[i]
		var button_label = _button_vbox_container_node.get_child(i)
		button_label.set_text(button_text)
	
	_update_button_selections()

func _move(move_amount:int):
	
	if _button_names.size() == 0:
		return
	
	var previously_selected_button = _selected_button
	
	_selected_button += move_amount
	
	while _selected_button < 0:
		_selected_button += _button_names.size()
	
	while _selected_button > _button_names.size() - 1:
		_selected_button -= _button_names.size()
	
	if previously_selected_button != _selected_button:
		_move_sound_player_node.play(0.0)
	
	_button_deselected(previously_selected_button)
	_button_selected(_selected_button)
	_update_button_selections()


func _update_button_selections():
	
	for i in _button_vbox_container_node.get_child_count():
		var button_label = _button_vbox_container_node.get_child(i)
		button_label.set_selected(i == _selected_button)

func select_button(button_index:int):
	
	if _button_names.size() == 0:
		return
	
	while button_index < 0:
		button_index += _button_names.size()
	
	while button_index > _button_names.size() - 1:
		button_index -= _button_names.size()
	
	var previous_button = _selected_button
	_selected_button = button_index
	
	_button_deselected(previous_button)
	_button_selected(_selected_button)
	_update_button_selections()


func _button_deselected(button_index:int):
	emit_signal("button_deselected", self, button_index)


func _button_selected(button_index:int):
	emit_signal("button_selected", self, button_index)
	


func _move_down():
	_move(1)


func _move_up():
	_move(-1)


func get_button_name(button_index:int):
	return _button_names[button_index]


func _press():
	emit_signal("button_pressed", self, _selected_button)
