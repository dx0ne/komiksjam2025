class_name Rocket
extends Node2D

var elements:int=0;
func _ready() -> void:
	$body.visible=false;
	$lewapletwa.visible=false;
	$prawapletwa.visible=false;
	$czubek.visible=false;
	$geba.visible=false;

func add():
	elements+=1;
	match elements:
		1:
			$body.visible=true;
		2:
			$lewapletwa.visible=true;
		3:
			$prawapletwa.visible=true;
		4:
			$czubek.visible=true;
		5:
			$geba.visible=true;
