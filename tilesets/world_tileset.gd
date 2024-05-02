tool
extends TileSet

const WATER = 8
const BRIDGE_H = 9
const BRIDGE_V = 10

var binds = {
	WATER: [BRIDGE_H, BRIDGE_V],
	BRIDGE_H: [WATER, BRIDGE_V],
	BRIDGE_V: [WATER, BRIDGE_H]
}

func _is_tile_bound(id, nid):
	return nid in binds[id]
