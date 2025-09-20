extends CharacterBody2D

class_name Hop

@onready var rid = get_rid()
@export var defaultSpeed = 20 * (10 / 8);
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;
@export var bonusJumps = 0;
@export var dashTimer = 200;
@export var jumpTimer = 15;
@export var canDash = 0;
@export var canClimb = 0;
@export var canSlide = 0;
@export var canSlam = 0;
@export var canAirJump = 0;
@export var hasLight = 0;
@export var enterVelocityX = 0;
@export var enterVelocityY = 0;
static var inLiquid = 0;

func _init():
	velocity.x = enterVelocityX;
	velocity.y = enterVelocityY;
	#canDash = 0;
func _physics_process(delta):
	var _vel = Vector2()
	var grav = 981
	var direction = Input.get_axis("p1left", "p1right")
	#This sets up the velocity text.
	$VelXLabel.text = str(velocity.x)
	$VelYLabel.text = str(velocity.y)
	slide_on_ceiling = false;
	$VelXLabel.text = str(velocity.x);
	$VelYLabel.text = str(velocity.y);
	$DashLabel.text = str(dashTimer);
	#floor_stop_on_slope = false;
	#These are mostly debug commands to check if abilities are working.
	#They could also be considered cheats of sorts.
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
	if Input.is_action_just_pressed("togglezoom"):
		if $Camera2D.zoom == Vector2(1, 1):
			$Camera2D.set_zoom(Vector2(2, 2));
			$ZoomIn.play();
		else:
			$Camera2D.set_zoom(Vector2(1, 1));
			$ZoomOut.play();
	if Input.is_action_just_pressed("reload"):
		get_tree().reload_current_scene();
		#$Painsound.play();
	if hasLight == 0:
		$ExiLight.visible = false;
	if hasLight == 1:
		$ExiLight.visible = true;
	if Input.is_action_just_pressed("p1flashlight"):
		if $ExiLight.visible == false:
			hasLight = 1;
		if $ExiLight.visible == true:
			hasLight = 0;
		$FlashlightToggle.play();
	#This is where the movement code begins.
	if Input.is_action_pressed("p1left"):
		velocity.x -= defaultSpeed;
	if Input.is_action_pressed("p1right"):
		velocity.x += defaultSpeed;
	if (velocity.x <= -300) or (velocity.x >= 300):
		velocity.x /= 1.01;
		if (velocity.x <= -400) or (velocity.x >= 400):
			velocity.x /= 1.01;
			#if (velocity.x <= -500) or (velocity.x >= 500):
				#velocity.x /= 1.01;
		if is_on_floor():
			velocity.x /= 1.053;
	if canDash >= 1:
		if dashTimer > 0:
			dashTimer -= 1;
		#if dashTimer <= 50 and dashTimer > 0:
			#$DashOKIndicator.hidden = false;
		#if dashTimer == 0:
			#$DashOKIndicator.hidden = true;
		if dashTimer == 1:
			$Airjumpsound.play();
		if dashTimer > 135 and velocity.y > 0:
			velocity.y = 0;
		if Input.is_action_just_pressed("p1dash"):
			if dashTimer < 1:
				if ($AnimatedSprite2D.flip_h == true):
					velocity.x -= 1500;
					if velocity.x > -1500:
						velocity.x = -1500;
				if ($AnimatedSprite2D.flip_h == false):
					velocity.x += 1500;
					if velocity.x < 1500:
						velocity.x = 1500;
				$Dashsound.play();
				dashTimer += 60;
				#if velocity.y > 0:
			else:
				$Painsound.play();
	#velocity.x *= 0.9;
		#if is_on_floor() and !Input.is_action_pressed("p1left") and !Input.is_action_pressed("p1right"):
			#velocity.x /= 1.01;
		#else:
			#velocity.x /= 1.005;
	#if Input.is_action_just_pressed("p1dash") and canDash >= 1:
		#if velocity.x < 0:
			#velocity.x = -2000;
		#else:
			#velocity.x = 2000;
		#$Dashsound.play();
		#if velocity.y > 0:
			#velocity.y = 0;
	
	if is_on_floor() and !Input.is_action_pressed("p1left") and !Input.is_action_pressed("p1right"):
		if (dashTimer < 1 or dashTimer > 60):
			velocity.x *= 0.5;
		else:
			velocity.x *= 0.95;
	if !is_on_floor():
		velocity.x *= 0.95;
		jumpTimer -= 1;
	if jumpTimer <= 0:
		if canAirJump == 1:
			jumpsLeft = 1 + bonusJumps;
		else:
			jumpsLeft = 0 + bonusJumps;
		
	
	if Input.is_action_just_pressed("p1down"):
		position.y += 1
	if Input.is_action_just_pressed("p1jump") and jumpsLeft > 0:
		if is_on_floor or is_on_wall:
			$Jumpsound.play();
			#You can perform a "flip" (note: character does not flip visually) by turning and quickly jumping.
			#A "flip" can go farther than a normal jump.
			if Input.is_action_pressed("p1left") and velocity.x > 0 and !Input.is_action_pressed("p1right"):
				velocity.x *= -2;
			if Input.is_action_pressed("p1right") and velocity.x < 0 and !Input.is_action_pressed("p1left"):
				velocity.x *= -2;
		if !is_on_floor and !is_on_wall:
			$Airjumpsound.play();
		if is_on_wall() and canClimb == 1:
			if $AnimatedSprite2D.flip_h == true:
				velocity.x += 300;
			else:
				velocity.x -= 300;
		
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
		jumpTimer = 15;
		if canAirJump == 1:
			jumpsLeft = 2 + bonusJumps;
		else:
			jumpsLeft = 1 + bonusJumps;
			
	#If the character is in a liquid zone (e.g. water), their vertical movement is slowed.
	#Fortunately, the character can "swim" (jump infinitely) like how Terraria's Flipper item works.
	if inLiquid:
		if canAirJump == 1:
			jumpsLeft = 2 + bonusJumps;
		else:
			jumpsLeft = 1 + bonusJumps;
		velocity.y *= 0.95;
	if is_on_wall() and canClimb == 1:
		jumpTimer = 15;
		if Input.is_action_pressed("p1left") or Input.is_action_pressed("p1right"):
			velocity.y *= 0.95;
		if canAirJump == 1:
			jumpsLeft = 2 + bonusJumps;
		else:
			jumpsLeft = 1 + bonusJumps;
	#motion = move_and_collide(motion)
	frame_selector();
	#frame_selector2 runs after frame_selector, so it's kind of a priority thing
	frame_selector2();
func frame_selector():
	#Given the existence of that whole Animator thing, I'm not sure this is normal.
	#This is kind of how I did it for that Terraria mod
	$AnimatedSprite2D.play();
	if Input.is_action_just_pressed("p1dash"):
		$AnimatedSprite2D.animation = "dash"
		$AnimatedSprite2D.flip_v = false
	if is_on_floor() and velocity.x > -1 and velocity.x < 1:
		$AnimatedSprite2D.animation = "idle"
	if (Input.is_action_pressed("p1left") or Input.is_action_pressed("p1right")) and (velocity.x != 0 and is_on_floor()):
		$AnimatedSprite2D.animation = "walk"
		if Input.is_action_pressed("p1left"):
			$AnimatedSprite2D.flip_h = true;
		if Input.is_action_pressed("p1right"):
			$AnimatedSprite2D.flip_h = false;
	else:
		$AnimatedSprite2D.animation = "idle"
		$AnimatedSprite2D.flip_v = false
func frame_selector2():
	if is_on_wall() and canClimb:
		$AnimatedSprite2D.animation = "wallclimb"
	if velocity.y < 0 and !is_on_wall():
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_v = false
		if Input.is_action_pressed("p1left"):
			$AnimatedSprite2D.flip_h = true;
		if Input.is_action_pressed("p1right"):
			$AnimatedSprite2D.flip_h = false;
	if velocity.y > 17 and !is_on_wall():
		$AnimatedSprite2D.animation = "fall"
		$AnimatedSprite2D.flip_v = false
		if Input.is_action_pressed("p1left"):
			$AnimatedSprite2D.flip_h = true;
		if Input.is_action_pressed("p1right"):
			$AnimatedSprite2D.flip_h = false;
	
#func _retired():
	
