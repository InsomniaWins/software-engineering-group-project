extends Control

const HEALTH_PER_HEART:int = 4
const SWORD_ITEM_ICON = preload("res://textures/items/icons/sword.png")
const BOW_ITEM_ICON = preload("res://textures/items/icons/bow.png")

onready var _hearts_node:Control = $Hearts
onready var _heart_nodes:Array = _hearts_node.get_children()
onready var _selected_item_icon_node:TextureRect = $SelectedItemIcon

func update_selected_item_icon(item_index:int):
	
	# TODO: add icon for bow
	match item_index:
		ItemManager.Items.SWORD:
			_selected_item_icon_node.texture = SWORD_ITEM_ICON
		_:
			_selected_item_icon_node.texture = null
	


func update_hearts(health:int, max_health:int):
	
	var active_heart:int = int(ceil(health / float(HEALTH_PER_HEART)) - 1)
	
	var heart_of_max_health:int = int(max_health / float(HEALTH_PER_HEART))-1
	
	for i in _heart_nodes.size():
		
		var heart_node = _heart_nodes[i]
		
		if i == active_heart:
			var frame:int = ((active_heart * HEALTH_PER_HEART) - health) + 4
			heart_node.frame = frame
		elif i < active_heart:
			heart_node.frame = 0
		elif i <= heart_of_max_health:
			heart_node.frame = 4
		else:
			heart_node.frame = 5
		
		
