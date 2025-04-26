class_name Player;
extends Node2D

var max_x_slot:int = 4;
var max_y_slot:int = 1;
var x_slot:int = 0;
var y_slot:int = 0;

@export var max_slots:int = 5;

signal moved(x,y);

signal action(type:Constants.ACTION);

func _physics_process(delta):
	var do_moved_signal:bool=false;
	
	if Input.is_action_just_pressed("go_left"):
		if(x_slot==0):
			print("action left");
			if(y_slot==0):
				action.emit(Constants.ACTION.TAKE_TAG);
		else:
			x_slot = max(0,x_slot-1);
			do_moved_signal=true;
			
	if Input.is_action_just_pressed("go_right"):
		if(x_slot==max_x_slot):
			if(y_slot==0):
				action.emit(Constants.ACTION.ROCKET);
			else:
				action.emit(Constants.ACTION.TRASH);
		else:
			x_slot = min(max_x_slot,x_slot+1);
			do_moved_signal=true;
			
	if Input.is_action_just_pressed("go_up"):
		if(y_slot==0):
			print("action up");
			action.emit(Constants.ACTION.UP);
		else:
			y_slot = max(0,y_slot-1);
			do_moved_signal=true;
			
	if Input.is_action_just_pressed("go_down"):
		if(y_slot==max_y_slot):
			print("action down");
			action.emit(Constants.ACTION.DOWN);
		else:
			y_slot = min(max_y_slot,y_slot+1);
			do_moved_signal=true;
	
	if(do_moved_signal):
		#print(x_slot,y_slot);
		moved.emit(x_slot,y_slot);
