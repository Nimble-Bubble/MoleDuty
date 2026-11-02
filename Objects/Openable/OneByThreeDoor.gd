extends Node2D

class_name OneByThreeDoor

#I don't think doors would have physics
func _process(delta: float) -> void:
	if ($AreaL.has_overlapping_areas() == true):
		$DoorSprite.animation = "openright";
		$DoorSolid/DoorColPoly.disabled = true;
	if ($AreaR.has_overlapping_areas() == true):
		$DoorSprite.animation = "openleft";
		$DoorSolid/DoorColPoly.disabled = true;
	else:
		$DoorSprite.animation = "default";
		$DoorSolid/DoorColPoly.disabled = false;
	
