extends Character
class_name Nightborne
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Hurtbox/CollisionShape2D
@onready var state_chart:StateChart = $StateChart
@onready var hitbox = $Hitbox
@onready var horizontal_move_component:MoveComponent = $HorizontalMoveComponent
@export var friction = 900
@export var dodge_speed = 100.0
@export var acceleration = 1000
@export var hitbox_offset = 46
var input_direction:float
var jump_position
var look_input_direction:float = 1

func _ready():
	speed=400

func _physics_process(_delta):
	if not is_on_floor():
		state_chart.send_event("to fall")
func move_character(direction,delta):
	super.move_character(direction,delta)
	if not is_on_floor():
		velocity.y += gravity * delta
	input_direction = direction
	if input_direction != 0: 
		look_input_direction = input_direction
		flip()
		state_chart.send_event("to run")
	horizontal_move_component.move(delta,Vector2(input_direction,0))


func jump():
	state_chart.send_event("to jump")

func attack():
	state_chart.send_event("to attack")

func dodge():
	state_chart.send_event("to dodge")

func flip():
	if input_direction < 0:
		animated_sprite_2d.flip_h = true
		hitbox.position.x = clamp(hitbox.position.x - hitbox_offset, -27, 27)
	elif input_direction > 0:
		animated_sprite_2d.flip_h = false
		hitbox.position.x = clamp(hitbox.position.x + hitbox_offset, -27, 27)

func _on_idle_state_entered():
	animation_player.play("idle")


func _on_run_state_entered():
	animation_player.play("run")


func _on_run_state_processing(delta):
	if input_direction == 0:
		state_chart.send_event("to idle")

func _on_attack_state_entered():
	animation_player.play("attack")


func _on_attack_state_processing(_delta):
	velocity=Vector2.ZERO # Replace with function body.


func _on_hurtbox_hitbox_entered(damage):
	health-=damage
