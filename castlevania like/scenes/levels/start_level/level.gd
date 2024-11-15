extends Node2D
class_name Level
@onready var phantom_camera_2d:PhantomCamera2D = %PhantomCamera2D

func _ready():
	call_deferred("_set_camera_target")
	PlayerGlobal.connect("character_changed",_set_camera_target)

func _set_camera_target():
	phantom_camera_2d.set_follow_target(PlayerGlobal.current_character)
