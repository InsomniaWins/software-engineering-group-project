extends Node

const FINAL_MAX_HEALTH:int = 72

var _max_health:int = 12
var _health:int = 12


func take_damage(damage_amount:int = 0):
	damage_amount = int(clamp(damage_amount, 0, _health))
	_health -= damage_amount
	
	if _health == 0:
		died()


func died():
	pass


func set_max_health(new_max_health):
	_max_health = int(clamp(new_max_health, 0, FINAL_MAX_HEALTH))

func set_health(new_health:int):
	_health = int(clamp(new_health, 0, _max_health))

func get_health() -> int:
	return _health

func get_max_health() -> int:
	return _max_health
