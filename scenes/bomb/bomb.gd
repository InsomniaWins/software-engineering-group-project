extends Node2D

const EXPLODE_SOUND:AudioStream = preload("res://sounds/bomb_explode.wav")

var explode_damage: int = 2

onready var blast_radius_node:Area2D = $BlastRadius

func explode():
	
	AudioManager.play_sound(EXPLODE_SOUND)
	
	var entities = blast_radius_node.get_overlapping_areas()
	for collider in entities:
		if collider.is_in_group("hit_box"):
			var entity = collider.get_parent()
			entity.take_damage(explode_damage)
	
	queue_free()


func _on_ExplodeTimer_timeout():
	explode()
