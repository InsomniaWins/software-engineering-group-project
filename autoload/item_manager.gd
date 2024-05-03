extends Node

enum Items {
	
	SWORD,
	BOW
	
}


var unlocked_items = [Items.SWORD, Items.BOW]


# TODO: return then next element of unlocked_items from
#       current_item's index in the unlocked_items array
func get_next_available_item(current_item:int) -> int:
	
	
	return Items.SWORD
