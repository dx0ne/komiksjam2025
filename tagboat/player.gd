class_name Player;
extends Node2D

var max_x_slot:int = 4;
var max_y_slot:int = 1;
var x_slot:int = 0;
var y_slot:int = 0;

@export var max_slots:int = 5;

signal moved(x,y);

func _physics_process(delta):
	var do_signal:bool=false;
	
	if Input.is_action_just_pressed("go_left"):
		x_slot = max(0,x_slot-1);
		do_signal=true;
	if Input.is_action_just_pressed("go_right"):
		x_slot = min(max_x_slot,x_slot+1);
		do_signal=true;
	if Input.is_action_just_pressed("go_up"):
		y_slot = max(0,y_slot-1);
		do_signal=true;
	if Input.is_action_just_pressed("go_down"):
		y_slot = min(max_y_slot,y_slot+1);
		do_signal=true;
	
	if(do_signal):
		#print(x_slot,y_slot);
		moved.emit(x_slot,y_slot);
