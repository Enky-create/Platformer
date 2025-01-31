extends Area2D
class_name CameraSwitchArea
signal change_camera(camera:PhantomCamera2D)
signal return_to_deafault()
@export var camera:PhantomCamera2D
func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	change_camera.emit(camera) 

func _on_body_exited(body):
	return_to_deafault.emit()
