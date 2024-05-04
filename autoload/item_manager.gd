extends Node

enum Items {
	SWORD,
	BOW,
	BOMB
}

var unlocked_items = [Items.SWORD]

func get_next_available_item(current_item: int) -> int:
	var next_index = (unlocked_items.find(current_item) + 1) % unlocked_items.size()
	return unlocked_items[next_index]


