extends Node2D

@onready var player:Player;

@onready var upper_player_slots:Array[Sprite2D] = [$playerLayer/Slot00, $playerLayer/Slot01, $playerLayer/Slot02, $playerLayer/Slot03, $playerLayer/Slot04];
@onready var lower_player_slots:Array[Sprite2D] = [$playerLayer/Slot10, $playerLayer/Slot11, $playerLayer/Slot12, $playerLayer/Slot13, $playerLayer/Slot14];

@onready var upper_tags:Array[Tags] = [$CanvasLayer/Node2D, $CanvasLayer/Node2D2, $CanvasLayer/Node2D3, $CanvasLayer/Node2D4, $CanvasLayer/Node2D5];
@onready var lower_tags:Array[Tags] = [$CanvasLayer/Node2D6, $CanvasLayer/Node2D7, $CanvasLayer/Node2D8, $CanvasLayer/Node2D10, $CanvasLayer/Node2D9];

@onready var upper_belt_slots:Array[Sprite2D] = [$playerLayer/BeltSlot00, $playerLayer/BeltSlot01, $playerLayer/BeltSlot02, $playerLayer/BeltSlot03, $playerLayer/BeltSlot04];
@onready var lower_belt_slots:Array[Sprite2D] = [$playerLayer/BeltSlot10, $playerLayer/BeltSlot11, $playerLayer/BeltSlot12, $playerLayer/BeltSlot13, $playerLayer/BeltSlot14];
var upper_belt:Array[Tshirt];
var lower_belt:Array[Tshirt];

var belt_items:Array[Tshirt];

var belt_interval=2;
var new_upper_belt_interval = belt_interval*4;
var belt_timer:Timer;

var randomized_tag:Constants.TAG = Constants.TAG.NONE;
var taken_randomized_tag:Constants.TAG = Constants.TAG.NONE;

func _ready() -> void:
	player = $playerLayer/Player;
	player.max_x_slot = upper_player_slots.size()-1;
	#belt timer setup
	belt_timer = Timer.new()
	belt_timer.connect("timeout",belt_timer_tick);
	belt_timer.wait_time = belt_interval
	add_child(belt_timer)
	
	add_new_tshirt(0);
	add_new_tshirt(1);
	
	#hide matrix
	hide_all_player_slots();
	hide_all_belt_slots();
	#show start states
	refresh_view_belt_slots();
	upper_player_slots[0].visible=true;

	belt_timer.start()
	
	give_random_tag();

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
	for i in belt_items.size():
		ts = belt_items[i];
		ts.slot = ts.slot + ts.dir;
		if (ts.slot<0 or ts.slot>upper_belt_slots.size()-1):
			print("spad");
		
	hide_all_belt_slots();
		
	refresh_view_belt_slots()
	
func hide_all_belt_slots():
	for i in upper_belt_slots.size():
		upper_belt_slots[i].visible=false;
	for i in lower_belt_slots.size():
		lower_belt_slots[i].visible=false;
	for i in upper_tags.size():
		upper_tags[i].visible=false;
	for i in lower_tags.size():
		lower_tags[i].visible=false;
		
func refresh_view_belt_slots():
	for i in belt_items.size():
		if(belt_items[i].slot<0 or belt_items[i].slot>upper_belt_slots.size()-1):
			continue;
		if(belt_items[i].belt==0):
			upper_belt_slots[belt_items[i].slot].visible = true;
		else:
			lower_belt_slots[belt_items[i].slot].visible = true;
		
var thisrt_class = load("res://tshirt.gd")
func add_new_tshirt(belt:int):
	var ts:Tshirt = thisrt_class.new();
	if( belt==0):
		ts.slot=4;
		ts.dir=-1;
	ts.tags[randi_range(0,2)]=1;
	ts.belt=belt;
	belt_items.append(ts);

func give_random_tag():
	randomized_tag = Constants.TAG.keys()[randi() % Constants.TAG.size()];
	match randomized_tag:
		Constants.TAG.WASH:
			$Node2D2/LaundryIconWashFull.visible=true;
		Constants.TAG.DRY:
			$Node2D2/LaundryIconIronFull.visible=true;
		Constants.TAG.IRON:
			$Node2D2/LaundryIconDryFull.visible=true;

func take_random_tag():
		$Node2D2/LaundryIconWashFull.visible=false;
		$Node2D2/LaundryIconIronFull.visible=false;
		$Node2D2/LaundryIconDryFull.visible=false;
		taken_randomized_tag = randomized_tag;
		randomized_tag = Constants.TAG.NONE;
