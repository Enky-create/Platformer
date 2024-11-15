extends Area2D
class_name Hurtbox
signal hitbox_entered(damage:int)
# Called when the node enters the scene tree for the first time.
func _init():
	collision_layer=0
	collision_mask=8

func _ready():
	self.connect("area_entered",_on_area_entered)

func _on_area_entered(hitbox:Hitbox):
	if hitbox == null : return
	hitbox_entered.emit(hitbox.damage)
