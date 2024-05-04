extends RayCast2D


var direction:Vector2 = Vector2.RIGHT

var _move_speed:float = 150.0
var _shooter = null setget set_shooter
var _arrow_length:float = 9


func _ready():
	rotation = direction.angle() + PI
	


func set_shooter(new_shooter):
	
	if _shooter != null:
		remove_exception(_shooter)
	
	_shooter = new_shooter
	add_exception(_shooter)
	

func _physics_process(delta):
	
	rotation = direction.angle() + PI
	
	# move arrow
	position += direction.normalized() * _move_speed * delta
	cast_to.x = -(_move_speed * delta + _arrow_length)
	force_raycast_update()
	
	# check collision
	if is_colliding():
		var collider = get_collider()
		
		if !collider.is_in_group("dont_break_arrows"):
			
			if collider.is_in_group("hit_box"):
				var entity = collider.get_parent()
				
				if entity.is_in_group("enemy"):
					var damage_amount:int = 1
					var knockback:Vector2 = 150 * direction
					
					entity.take_damage(damage_amount, knockback)
			
			queue_free()
