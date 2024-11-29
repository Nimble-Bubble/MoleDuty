extends CharacterBody2D

@onready var rid = get_rid()
@export var defaultSpeed = 40 * (10 / 8);
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;
@export var bonusJumps = 0;
@export var dashTimer = 200;
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
	$VelXLabel.text = str(velocity.x)
	$VelYLabel.text = str(velocity.y)
	slide_on_ceiling = false;
	$VelXLabel.text = str(velocity.x);
	$VelYLabel.text = str(velocity.y);
	$DashLabel.text = str(dashTimer);
	#floor_stop_on_slope = false;
	if Input.is_action_just_pressed("togglevelocitylabel"):
		$VelXLabel.visible = true;
		$VelYLabel.visible = true;
		$DashLabel.visible = true;
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
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene();
		#$Painsound.play;
	#if Input.is_action_just_pressed("debugvelocity"):
		#$VelDebug.visible = true;
		#$VelXLabel.visible = true;
		#$VelYLabel.visible = true;
		#$DashLabel.visible = true;
	if Input.is_action_pressed("p1left"):
		velocity.x -= defaultSpeed;
	if Input.is_action_pressed("p1right"):
		velocity.x += defaultSpeed;
	if (velocity.x <= -300) or (velocity.x >= 300):
		velocity.x /= 1.01;
		if (velocity.x <= -400) or (velocity.x >= 400):
			velocity.x /= 1.02;
			if (velocity.x <= -500) or (velocity.x >= 500):
				velocity.x /= 1.03;
	if canDash >= 1:
		if dashTimer > 0:
			dashTimer -= 1;
		#if dashTimer <= 50 and dashTimer > 0:
			#$DashOKIndicator.hidden = false;
		#if dashTimer == 0:
			#$DashOKIndicator.hidden = true;
		if dashTimer == 50:
			$Airjumpsound.play;
		if dashTimer > 135:
			velocity.y = 0;
		if Input.is_action_just_pressed("p1dash"):
			if dashTimer < 50:
				if velocity.x < 0:
					velocity.x = -2000;
				else:
					velocity.x = 2000;
				$Dashsound.play();
				dashTimer += 150;
				#if velocity.y > 0:
			else:
				$Painsound.play();
	#velocity.x *= 0.9;
		if is_on_floor():
			velocity.x /= 1.01;
		else:
			velocity.x /= 1.005;
	#if Input.is_action_just_pressed("p1dash") and canDash >= 1:
		#if velocity.x < 0:
			#velocity.x = -2000;
		#else:
			#velocity.x = 2000;
		#$Dashsound.play();
		#if velocity.y > 0:
			#velocity.y = 0;
	
	if is_on_floor():
		velocity.x *= 0.9;
	if !is_on_floor():
		velocity.x *= 0.95;
	
	if Input.is_action_just_pressed("p1jump") and jumpsLeft > 0:
		if is_on_floor or is_on_wall:
			$Jumpsound.play();
		if !is_on_floor and !is_on_wall:
			$Airjumpsound.play();
		if is_on_wall() and canClimb == 1:
			if velocity.x < 0:
				velocity.x -= 300;
			else:
				velocity.x += 300;
		
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
	
