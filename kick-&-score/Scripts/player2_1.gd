extends CharacterBody2D

""" Const variables """ 
# Speed 
const SPEED = 100.0
const GAIN := 1.0            			# rate: ball ≈ GAIN * player_velocity
const MAX_BALL_SPEED := 500  			# max velocity for the ball (px/s)
const SPRINT_MULT := 1.8
# Stamina
const MAX_STAMINA := 100.0
const STAMINA_DRAIN := 30.0            	# decrease/th.s when sprinting
const STAMINA_RECOVER_MOVE := 5.0     	# recover/th.s when walking
const STAMINA_RECOVER_IDLE := 25.0     	# recover/th.s when idling
const STAMINA_MIN_TO_SPRINT := 10.0   


var stamina: float = 0.0
@onready var bar: ProgressBar = $ProgressBar

var current_dir = "none"
var pushing_ball = false
var ball: RigidBody2D = null  

# State
var movement = false
var sprint = true	

func _ready() -> void:
	print("Initialize Player object")
	
	# Initialize stamina
	stamina = MAX_STAMINA
	bar.min_value = 0
	bar.max_value = MAX_STAMINA
	bar.value = stamina

	$AnimatedSprite2D.play("idle")

func _physics_process(delta: float) -> void:
	player_movement(delta)

func player_movement(delta: float) -> void:
	var accelerate := SPEED
	if Input.is_action_pressed("ui_sprint_2") and stamina >= STAMINA_MIN_TO_SPRINT:
		sprint = true
		accelerate *= SPRINT_MULT 
	else:
		sprint = false

	if Input.is_action_pressed("ui_right_2"):
		current_dir = "right"
		movement = true
		velocity.x = accelerate
		velocity.y = 0
	elif Input.is_action_pressed("ui_left_2"):
		current_dir = "left"
		movement = true
		velocity.x = -accelerate
		velocity.y = 0
	elif Input.is_action_pressed("ui_down_2"):
		current_dir = "down"
		movement = true
		velocity.x = 0
		velocity.y = accelerate
	elif Input.is_action_pressed("ui_up_2"):
		current_dir = "up"
		movement = true
		velocity.x = 0
		velocity.y = -accelerate
	else:
		movement = false
		velocity = Vector2.ZERO

	move_and_slide()
	stamina_bar(delta)
	play_anim()

func play_anim() -> void:
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement:
			anim.play("walk_side")
		elif not movement:
			anim.play("idle")
	
	if dir == "left":
		anim.flip_h = true
		if movement:
			anim.play("walk_side")
		elif not movement:
			anim.play("idle")
	
	if dir == "up":
		anim.flip_h = false
		if movement:
			anim.play("walk_back")
		elif not movement:
			anim.play("idle")
		
	if dir == "down":
		anim.flip_h = false
		if movement:
			anim.play("walk_front")
		elif not movement:
			anim.play("idle")

func stamina_bar(delta: float) -> void:
	if sprint:
		stamina -= STAMINA_DRAIN * delta
	else:
		stamina += (STAMINA_RECOVER_MOVE if movement else STAMINA_RECOVER_IDLE) * delta

	stamina = clamp(stamina, 0.0, MAX_STAMINA)  # chỉ cần 1 lần
	bar.value = stamina
	
