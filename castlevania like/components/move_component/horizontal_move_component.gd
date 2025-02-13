extends MoveComponent
class_name HorizontalMoveComponent
@export var friction = 900
@export var acceleration = 1000
@export var speed=200


func  move(delta,direction:Vector2):
	if direction.x != 0: 
		character.velocity.x = move_toward(character.velocity.x, direction.x*speed, acceleration * delta)
	else:
		character.velocity.x = move_toward(character.velocity.x, 0, friction * delta)
	character.move_and_slide()
	
