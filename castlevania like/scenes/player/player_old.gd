extends CharacterBody2D
class_name PlayerOld 
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $Hurtbox/CollisionShape2D
@onready var state_chart:StateChart = $StateChart
@onready var hitbox = $Hitbox

@export var speed = 200.0
@export var dodge_speed = 350.0
@export var jump_velocity = -400.0
@export var acceleration = 1000
@export var friction = 900
@export var hitbox_offset = 46
@export var health:int = 100:
	set(value):
		health = clamp(value,0,maxhealth)
@export var maxhealth:int=100
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction:float
var jump_position
var look_direction:float=1
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	var previous = direction
	direction = Input.get_axis("left_walk", "right_walk")
	if direction !=0: look_direction=direction
	#Flip sprite
	if direction != previous:
		flip()
	
	if Input.get_axis("left_walk", "right_walk")!=0 and not Input.is_action_just_pressed("dodge"):
		state_chart.send_event("to run")

func flip():
	if direction <0:
		animated_sprite_2d.flip_h=true
		hitbox.position.x=clamp(hitbox.position.x-hitbox_offset,-27,27)
	else: if direction > 0:
		animated_sprite_2d.flip_h=false
		hitbox.position.x=clamp(hitbox.position.x+hitbox_offset,-27,27)

#//////STATE CHART STATES

func _on_idle_state_entered():
	velocity=Vector2.ZERO
	animation_player.play("idle")

func _on_hurtbox_hitbox_entered(damage):
	health-=damage
	if health<=0:
		queue_free()

func _on_jump_state_entered():
	animation_player.play("jump")
	#velocity=Vector2.ZERO 
	jump_position=velocity.y
	if  is_on_floor():
		velocity.y = jump_velocity
		move_and_slide()

func _on_jump_state_processing(_delta):
	if velocity.y >0 and animation_player.current_animation!="jump_to_fall":
		animation_player.play("jump_to_fall")
	if is_on_floor():
		state_chart.send_event("to idle")

func _on_jump_state_physics_processing(_delta):
	if Input.is_action_just_released("jump") and velocity.y < jump_velocity/2:
		velocity.y = jump_velocity/2
	move_and_slide()

func _on_run_state_entered():
	animation_player.play("run")
	velocity=Vector2.ZERO 


func _on_run_state_processing(_delta):
	if Input.is_action_just_pressed("dodge"):
		state_chart.send_event("to dodge")
	if !direction:
		state_chart.send_event("to idle")
	if Input.is_action_just_pressed("jump"):
		state_chart.send_event("to jump")
	


func _on_dodge_state_entered():
	velocity=Vector2.ZERO 
	animation_player.play("roll") 


func _on_dodge_state_processing(_delta):
	if not animation_player.is_playing():
		if Input.is_action_just_pressed("jump"):
			state_chart.send_event("to jump")
		state_chart.send_event("to idle")


func _on_run_state_physics_processing(delta):
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed,acceleration*delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction*delta)
	move_and_slide()


func _on_dodge_state_physics_processing(_delta):
	velocity.x = look_direction*dodge_speed
	move_and_slide()


func _on_idle_state_input(_event):
	if Input.is_action_just_pressed("dodge"):
		state_chart.send_event("to dodge")
	if Input.is_action_just_pressed("jump"):
		state_chart.send_event("to jump")
	if Input.is_action_just_pressed("attack"):
		state_chart.send_event("to attack")





func _on_light_attack_state_entered():
	animation_player.play("attack_nomovement")


func _on_light_attack_state_processing(_delta):
	if not animation_player.is_playing():
		if Input.is_action_just_pressed("attack"):
			state_chart.send_event("to hard attack")
		#state_chart.send_event("to idle")


func _on_hard_attack_state_entered():
	animation_player.play("attack2_nomovement")


func _on_hard_attack_state_physics_processing(_delta):
	if not animation_player.is_playing():
		state_chart.send_event("to idle")


func _on_run_state_input(_event):
	if Input.is_action_just_pressed("attack"):
		state_chart.send_event("to attack")
