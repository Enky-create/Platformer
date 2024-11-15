extends Character
class_name HeavyKnight
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

func _physics_process(delta):
	if not is_on_floor():
		state_chart.send_event("to fall")
	if health<=0:
		state_chart.send_event("to death")

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


func _on_run_state_entered():
	animation_player.play("run")


func _on_dodge_state_entered():
	velocity=Vector2.ZERO
	animation_player.play("roll") # Replace with function body.


func _on_dodge_state_physics_processing(delta):
	if not animation_player.is_playing():
		state_chart.send_event("to idle")
	velocity.x = look_direction*dodge_speed
	move_and_slide()
	

func _on_idle_state_entered():
	animation_player.play("idle")


func _on_fall_state_entered():
		animation_player.play("jump_to_fall") 


func _on_fall_state_processing(_delta):
	if is_on_floor(): 
		state_chart.send_event("to idle") 


func _on_run_state_processing(delta):
	if !direction:
		state_chart.send_event("to idle")
	velocity.x = move_toward(velocity.x, direction * speed,acceleration*delta)


func _on_light_attack_state_entered():
	velocity.x= 0
	animation_player.play("attack_nomovement")



func _on_hard_attack_state_entered():
	if not animation_player.is_playing():
		animation_player.play("attack2_nomovement")


func _on_hard_attack_state_processing(delta):
	if not animation_player.is_playing():
		state_chart.send_event("to idle")


func _on_jump_state_entered():
	animation_player.play("jump")
	if  is_on_floor():
		velocity.y = jump_velocity
		move_and_slide()


func _on_jump_state_processing(delta):
	if Input.is_action_just_released("jump") and velocity.y < jump_velocity/2:
		velocity.y = jump_velocity/2
	move_and_slide()

func _on_death_state_entered():
	animation_player.play("death_nomovement")
	PlayerGlobal.character_died(self)

func _on_hit_state_entered():
	animation_player.play("hit")

func _on_hurtbox_hitbox_entered(damage):
	state_chart.send_event("to hit")
	health-=damage
