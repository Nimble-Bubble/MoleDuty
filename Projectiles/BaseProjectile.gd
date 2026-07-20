extends Node

class_name BaseProjectile;

# Having the damage types be separate like this might make damage calculations complicated 
@export var damageStab = 0;
@export var damageSlash = 0;
@export var damageBlunt = 0;

func _init():
	damageStab = 0;
	damageSlash = 0;
	damageBlunt = 0;
