extends Control

const HEALTH_PER_HEART:int = 4

onready var _hearts_node:Control = $Hearts
onready var _heart_nodes:Array = _hearts_node.get_children()


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
		
		
