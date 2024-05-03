extends Node2D

var explode_damage: int = 2

var _exploded: bool = false

onready var blast_radius_node = $BlastRadius

func _ready():
	explode()

func explode():
	if _exploded: 
		return
	_exploded = true
	
	
func _physics_process(delta):
	if _exploded: 
		_explode_phy()
		
		
func _explode_phy():
	var entities = blast_radius_node.get_overlapping_bodies()
	for collider in entities:
		if collider.is_in_group("hit_box"):
			var entity = collider.get_parent()
			entity.take_damage(explode_damage)
	queue_free()
