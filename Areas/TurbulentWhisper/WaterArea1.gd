extends Area2D

var body;
var ExileinLiquid = Exile.inLiquid;

func body_entered():
	if body is Exile:
		ExileinLiquid = 1;
func body_exited():
	if body is Exile:
		ExileinLiquid = 0;
