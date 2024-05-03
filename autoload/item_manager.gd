extends Node

enum Items {
    SWORD,
    BOW
}

var unlocked_items = [Items.SWORD, Items.BOW]

func get_next_available_item(current_item: int) -> Items:
    var next_index = (current_item + 1) % unlocked_items.size()
    return unlocked_items[next_index]

var current_item_index = Items.SWORD
var next_item = get_next_available_item(current_item_index)
print("Next available item:", next_item)
