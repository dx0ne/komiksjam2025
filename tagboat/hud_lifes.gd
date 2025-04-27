class_name HUDLifes
extends Node2D

func set_lifes(lifes:int):
	match lifes:
		0:
			$FilledDot.visible=false;
			$FilledDot2.visible=false;
			$FilledDot3.visible=false;
		1:
			$FilledDot.visible=true;
			$FilledDot2.visible=false;
			$FilledDot3.visible=false;
		2:
			$FilledDot.visible=true;
			$FilledDot2.visible=true;
			$FilledDot3.visible=false;
		3:
			$FilledDot.visible=true;
			$FilledDot2.visible=true;
			$FilledDot3.visible=true;
			
