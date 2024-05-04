extends Area2D


var velocity:Vector2 = Vector2.ZERO


func _physics_process(delta):
	position += velocity * delta


func _on_LeftEnemyMagic_body_entered(body):
	
	if body.is_in_group("enemy"):
		return
	
	if body.is_in_group("player"):
		
		var damage_amount:int = 3
		var knockback:Vector2 = 100 * (body.global_position - global_position).normalized()
		
		body.take_damage(damage_amount, knockback)
	
	queue_free()
