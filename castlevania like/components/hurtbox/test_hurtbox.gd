extends Node2D
@onready var hurtbox:Hurtbox = $Hurtbox


func _on_hurtbox_body_entered(_body):
	print("body_entered") # Replace with function body.


func _on_hurtbox_hitbox_entered(damage):
	print("aaaaa")
	print(damage)
	pass # Replace with function body.
