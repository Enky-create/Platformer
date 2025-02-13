extends Node
class_name OrientationComponent

@export var animated_sprite: AnimatedSprite2D
@export var hitbox: Node2D
@export var hitbox_offset: int = 46
@export var max_hitbox_offset:int=27

var look_direction: float = 1.0

func update_orientation(direction: float) -> void:
	if direction == 0:
		return
	look_direction = sign(direction)
	apply_visuals()

func apply_visuals() -> void:
	animated_sprite.flip_h = look_direction < 0
	adjust_hitbox_position()

func adjust_hitbox_position() -> void:
	var target_offset = hitbox_offset * look_direction
	hitbox.position.x = clamp(target_offset, -max_hitbox_offset, max_hitbox_offset)
