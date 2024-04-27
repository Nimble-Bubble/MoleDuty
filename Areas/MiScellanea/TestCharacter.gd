extends CharacterBody2D

@onready var rid = get_rid()
@export var defaultSpeed = 2.5;
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;

func _physics_process(delta):
	var _vel = Vector2()
	var grav = 150
	
	velocity.y += delta * grav;
	if is_on_floor:
		jumpsLeft = 1;
	if Input.is_action_pressed("p1left"):
		velocity.x -= 25;
	if Input.is_action_pressed("p1right"):
		velocity.x += 25;
	if Input.is_action_just_pressed("p1jump") and jumpsLeft > 0:

		$Jumpsound.play();
		velocity.y -= 200;
		jumpsLeft -= 1;
	var motion = velocity * delta
	move_and_collide(motion)
	frame_selector();
func frame_selector():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
	if velocity.y != 0:
		$AnimatedSprite2D.animation = "jump"
		$AnimatedSprite2D.flip_v = false
	else:
		$AnimatedSprite2D.animation = "idle"
