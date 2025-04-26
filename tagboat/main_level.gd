extends Node2D

@onready var upper_player_slots:Array[Sprite2D] = [$playerLayer/Slot00, $playerLayer/Slot01, $playerLayer/Slot02, $playerLayer/Slot03, $playerLayer/Slot04];
@onready var lower_player_slots:Array[Sprite2D] = [$playerLayer/Slot10, $playerLayer/Slot11, $playerLayer/Slot12, $playerLayer/Slot13, $playerLayer/Slot14];
@onready var player:Player;

@onready var upper_belt_slots:Array[Sprite2D] = [$playerLayer/BeltSlot00, $playerLayer/BeltSlot01, $playerLayer/BeltSlot02, $playerLayer/BeltSlot03, $playerLayer/BeltSlot04];
var upper_belt:Array[Tshirt];
var lower_belt:Array[int] = [0,0,0,0,0];

var belt_interval=2;
var new_upper_belt_interval = belt_interval*4;
var belt_timer:Timer;

func _ready() -> void:
	player = $playerLayer/Player;
	player.max_x_slot = upper_player_slots.size()-1;
	#belt timer setup
	belt_timer = Timer.new()
	belt_timer.connect("timeout",belt_timer_tick);
	belt_timer.wait_time = belt_interval
	add_child(belt_timer)
	
	add_new_tshirt();
	
	#hide matrix
	hide_all_player_slots();
	hide_all_upper_belt_slots();
	#show start states
	refresh_view_upper_belt_slots();
	upper_player_slots[0].visible=true;

	belt_timer.start()

func _on_player_moved(x: Variant, y: Variant) -> void:
	hide_all_player_slots()
	if(y==0):
		upper_player_slots[x].visible=true;
	else:
		lower_player_slots[x].visible=true;
	pass # Replace with function body.

func hide_all_player_slots():
	for i in upper_player_slots.size():
		upper_player_slots[i].visible=false;
	for i in lower_player_slots.size():
		lower_player_slots[i].visible=false;
		
func belt_timer_tick():
	var ts:Tshirt;
	print(upper_belt[0])
	for i in upper_belt.size():
		ts = upper_belt[i];
		ts.slot = max(0,ts.slot-1);
		
	hide_all_upper_belt_slots();
		
	refresh_view_upper_belt_slots()
	
func hide_all_upper_belt_slots():
	for i in upper_belt_slots.size():
		upper_belt_slots[i].visible=false;
		
func refresh_view_upper_belt_slots():
	for i in upper_belt.size():
		upper_belt_slots[upper_belt[i].slot].visible = true;

var thisrt_class = load("res://tshirt.gd")
func add_new_tshirt():
	var ts:Tshirt = thisrt_class.new();
	ts.slot=4;
	ts.tags[0]=1;
	upper_belt.append(ts);
