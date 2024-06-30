extends CharacterBody2D

@onready var rid = get_rid()
@export var defaultSpeed = 25;
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;
@export var bonusJumps = 0;
@export var dashTimer = 60;
var canDash;
var canClimb;
var canSlide;
var canSlam;
var canAirJump;

func _init():
	velocity.y = 10;
	canDash = 0;
func _physics_process(delta):
	var _vel = Vector2()
	var grav = 981
	slide_on_ceiling = false;
	#floor_stop_on_slope = false;
	if Input.is_action_just_pressed("toggledash"):
		$DashUnlock.play();
		if canDash == 1:
			canDash = 0;
		else:
			canDash = 1;
	if Input.is_action_just_pressed("toggleclimb"):
		$WallClimbUnlock.play();
		if canClimb == 1:
			canClimb = 0;
		else:
			canClimb = 1;
	if Input.is_action_just_pressed("toggleslide"):
		$SlideUnlock.play();
		if canSlide == 1:
			canSlide = 0;
		else:
			canSlide = 1;
	if Input.is_action_just_pressed("toggleslam"):
		$SlamUnlock.play();
		if canSlam == 1:
			canSlam = 0;
		else:
			canSlam = 1;
	if Input.is_action_just_pressed("toggleairjump"):
		$AirJumpUnlock.play();
		if canAirJump == 1:
			canAirJump = 0;
		else:
			canAirJump = 1;
	if Input.is_action_pressed("p1left"):
		velocity.x -= defaultSpeed;
	if Input.is_action_pressed("p1right"):
		velocity.x += defaultSpeed;
	if (velocity.x <= -500) or (velocity.x >= 500):
		velocity.x /= 1.01;
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
		if is_on_wall() and canClimb == 1:
			if velocity.x < 0:
				velocity.x -= 400;
			else:
				velocity.x += 400;
		$Jumpsound.play();
		if (velocity.y > 0 and !Input.is_action_pressed("p1down")):
			velocity.y = 0;
		velocity.y = -500;
		jumpsLeft -= 1;
	var _motion = velocity * delta
	move_and_slide();
	if !is_on_floor():
		velocity.y += delta * grav;
	if is_on_floor():
		#if (velocity.y < 0):
			#velocity.y = 0;
		if canAirJump == 1:
			jumpsLeft = 2 + bonusJumps;
		else:
			jumpsLeft = 1 + bonusJumps;
	if is_on_wall() and canClimb == 1:
		if canAirJump == 1:
			jumpsLeft = 2 + bonusJumps;
		else:
			jumpsLeft = 1 + bonusJumps;
	#motion = move_and_collide(motion)
	frame_selector();
func frame_selector():
	if Input.is_action_just_pressed("p1dash"):
		$AnimatedSprite2D.animation = "dash"
		$AnimatedSprite2D.flip_v = false
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_v = false
	if velocity.x != 0 and Input.is_action_pressed("p1right") or velocity.x != 0 and Input.is_action_pressed("p1left"):
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
#func _retired():
	
