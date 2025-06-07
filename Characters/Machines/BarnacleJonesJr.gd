extends CharacterBody2D

class_name BarnacleJonesJr

@export var startTheOtherWay = 0;
@export var MaxHP = 10;
var HP;

#Set health to maximum when created.
func _init():
	HP = MaxHP;

#When no target is detected, the enemy will "patrol" by moving back and forth.
#When the enemy hits a wall, it will turn around.
