extends Node2D
class_name Projectile
@onready var timer = $Timer
var direction:Vector2 = Vector2.RIGHT
@export var speed:int=10
@export var time:float=5
@onready var animated_sprite_2d:AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	top_level=true
	timer.wait_time=time
	animated_sprite_2d.flip_h= direction.x > 0
	reparent(get_tree().current_scene)
	
func _physics_process(delta):
	self.position+=direction*speed*delta

func _on_timer_timeout():
	queue_free()
	pass


func _on_area_2d_body_entered(_body):
	queue_free()
	pass
