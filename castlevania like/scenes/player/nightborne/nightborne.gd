extends Character
class_name Nightborne
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Hurtbox/CollisionShape2D
@onready var state_chart:StateChart = $StateChart
@onready var hitbox = $Hitbox
@export var friction = 900
@export var dodge_speed = 100.0
@export var acceleration = 1000
@export var hitbox_offset = 46
var direction:float
var jump_position
var look_direction:float = 1

func _ready():
	speed=400

func _physics_process(_delta):
	if not is_on_floor():
		state_chart.send_event("to fall")
func move_character(delta):
	super.move_character(delta)
	if not is_on_floor():
		velocity.y += gravity * delta

	direction = Input.get_axis("left_walk", "right_walk")
	if direction != 0: 
		look_direction = direction
		flip()
		state_chart.send_event("to run")
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	move_and_slide()

func jump():
	state_chart.send_event("to jump")

func attack():
	state_chart.send_event("to attack")

func dodge():
	state_chart.send_event("to dodge")

func flip():
	if direction < 0:
		animated_sprite_2d.flip_h = true
		hitbox.position.x = clamp(hitbox.position.x - hitbox_offset, -27, 27)
	elif direction > 0:
		animated_sprite_2d.flip_h = false
		hitbox.position.x = clamp(hitbox.position.x + hitbox_offset, -27, 27)

func _on_idle_state_entered():
	animation_player.play("idle")


func _on_run_state_entered():
	animation_player.play("run")


func _on_run_state_processing(delta):
	velocity.x = move_toward(velocity.x, speed*direction, acceleration * delta)
	if direction == 0:
		state_chart.send_event("to idle")

func _on_attack_state_entered():
	animation_player.play("attack")


func _on_attack_state_processing(_delta):
	velocity=Vector2.ZERO # Replace with function body.


func _on_hurtbox_hitbox_entered(damage):
	health-=damage
