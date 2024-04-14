extends CharacterBody2D

@export var defaultSpeed = 2.5;
@export var defaultAcceleration = 10;
@export var jumpsLeft = 1;

func _process(delta):
	var velocity = Vector2.ZERO
	
	velocity.y -= 0.5;
	if Input.is_action_pressed("p1left"):
		velocity.x -= 0.25;
	if Input.is_action_pressed("p1right"):
		velocity.x += 0.25;
	if Input.is_action_just_pressed("p1jump"):
		velocity.y += 5;
