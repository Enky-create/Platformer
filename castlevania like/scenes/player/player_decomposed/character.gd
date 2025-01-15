extends CharacterBody2D
class_name Character

@export var speed = 200.0
@export var type:CharacterTypes.CharacterType=CharacterTypes.CharacterType.Knight
@export var jump_velocity = -400.0
@export var health:int = 100:
	set(value):
		health = clamp(value, 0, maxhealth)
@export var maxhealth:int = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func move_character(_delta):
	PlayerGlobal.current_character_position=global_position
func jump():
	pass
func attack():
	pass
func dodge():
	pass
func interact():
	pass
	
func take_damage(damage:int):
	health -= damage
	if health <= 0:
		queue_free()
func reset():
	pass

