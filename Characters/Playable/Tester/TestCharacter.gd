extends CharacterBody2D

@onready var rid = get_rid()
@export var defaultSpeed = 2.5;
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;
var canDash;

func _init():
	velocity.y = 10;
	canDash = 0;
func _physics_process(delta):
	var _vel = Vector2()
	var grav = 490
	slide_on_ceiling = false;
	floor_stop_on_slope = false;
	#if !is_on_floor:
	velocity.y += delta * grav;
	if is_on_floor:
		#if (velocity.y < 0):
			#velocity.y = 0;
		jumpsLeft = 1;
		#if !Input.is_action_just_pressed("p1jump"):
			#velocity.y = 0; }
	if Input.is_action_just_pressed("toggledash"):
		$ToggleDash.play();
		if canDash == 1:
			canDash = 0;
		else:
			canDash = 1;
	if Input.is_action_pressed("p1left"):
		velocity.x -= 25;
	if Input.is_action_pressed("p1right"):
		velocity.x += 25;
	if (velocity.x <= -500) or (velocity.x >= 500):
		velocity.x *= 0.95;
	if Input.is_action_just_pressed("p1dash") and canDash >= 1:
		if velocity.x < 0:
			velocity.x = -1000;
		else:
			velocity.x = 1000;
		$Dashsound.play();
		if velocity.y > 0:
			velocity.y = 0;
	velocity.x *= 0.9;
	if Input.is_action_just_pressed("p1jump") and jumpsLeft > 0:

		$Jumpsound.play();
		if (velocity.y > 0 and !Input.is_action_pressed("p1down")):
			velocity.y = 0;
		velocity.y -= 350;
		jumpsLeft -= 1;
	var _motion = velocity * delta
	#motion = move_and_collide(motion)
	move_and_slide();
	frame_selector();
func frame_selector():
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_v = false
	if velocity.x != 0 and Input.is_action_pressed("p1right") or velocity.x != 0 and Input.is_action_pressed("p1left"):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
