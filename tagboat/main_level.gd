extends Node2D

@onready var player:Player;

@onready var upper_player_slots:Array[AnimatedSprite2D] = [$playerLayer/Slot00, $playerLayer/Slot01, $playerLayer/Slot02, $playerLayer/Slot03, $playerLayer/Slot04];
@onready var lower_player_slots:Array[AnimatedSprite2D] = [$playerLayer/Slot10, $playerLayer/Slot11, $playerLayer/Slot12, $playerLayer/Slot13, $playerLayer/Slot14];

@onready var upper_tags:Array[Tags] = [$CanvasLayer/Node2D, $CanvasLayer/Node2D2, $CanvasLayer/Node2D3, $CanvasLayer/Node2D4, $CanvasLayer/Node2D5];
@onready var lower_tags:Array[Tags] = [$CanvasLayer/Node2D6, $CanvasLayer/Node2D7, $CanvasLayer/Node2D8, $CanvasLayer/Node2D10, $CanvasLayer/Node2D9];

@onready var upper_belt_slots:Array[Sprite2D] = [$tshirtLayer/BeltSlot00, $tshirtLayer/BeltSlot01, $tshirtLayer/BeltSlot02, $tshirtLayer/BeltSlot03, $tshirtLayer/BeltSlot04];
@onready var lower_belt_slots:Array[Sprite2D] = [$tshirtLayer/BeltSlot10, $tshirtLayer/BeltSlot11, $tshirtLayer/BeltSlot12, $tshirtLayer/BeltSlot13, $tshirtLayer/BeltSlot14];
var upper_belt:Array[Tshirt];
var lower_belt:Array[Tshirt];

var belt_items:Array[Tshirt];

var belt_interval=2;
var new_upper_belt_interval = belt_interval*4;
var belt_timer:Timer;

var randomized_tag:Constants.TAG = Constants.TAG.NONE;
var taken_randomized_tag:Constants.TAG = Constants.TAG.NONE;

var trash_fill:int=0;

var points:int = 0;

var lifes:int = 3;
var spawntimer:Timer = Timer.new();

var lastSpawnedBelt:int=0;

func _ready() -> void:
	player = $playerLayer/Player;
	player.max_x_slot = upper_player_slots.size()-1;
	#belt timer setup
	belt_timer = Timer.new()
	belt_timer.connect("timeout",belt_timer_tick);
	belt_timer.wait_time = belt_interval
	add_child(belt_timer)
	
	#hide matrix
	hide_all_player_slots();
	hide_all_belt_slots();
	#show start states
	refresh_view_belt_slots();
	upper_player_slots[0].visible=true;

	belt_timer.start()
	
	deplete_taken_tag();
	hide_all_random_tags();
	give_random_tag();
	
	
	spawntimer.one_shot=true;
	spawntimer.wait_time=1;
	spawntimer.connect("timeout",after_start);
	add_child(spawntimer)
	spawntimer.start();

func after_start():
	add_new_tshirt(0);

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
		upper_player_slots[i].frame=0;
	for i in lower_player_slots.size():
		lower_player_slots[i].visible=false;
		lower_player_slots[i].frame=0;
		
func belt_timer_tick():
	var ts:Tshirt;
	for i in belt_items.size():
		ts = belt_items[i];
		ts.slot = ts.slot + ts.dir;
		if (ts.slot<0 or ts.slot>upper_belt_slots.size()-1):
			print("spad");
			if(ts.is_fully_filled()==false):
				loose_life();
			belt_items[i].marked_for_delete=true;
	for i in range(belt_items.size()-1,-1,-1):
		if(belt_items[i].marked_for_delete):
			spawn_another_tshirt();#add_new_tshirt(belt_items[i].belt);
			belt_items.remove_at(i);

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
			upper_tags[belt_items[i].slot].hide_all();
			upper_tags[belt_items[i].slot].show_all_needed(belt_items[i].tags_needed);
			upper_tags[belt_items[i].slot].show_all_filled(belt_items[i].tags_filled);
			upper_tags[belt_items[i].slot].visible = true;
			upper_belt_slots[belt_items[i].slot].visible = true;
		else:
			lower_tags[belt_items[i].slot].hide_all();
			lower_tags[belt_items[i].slot].show_all_needed(belt_items[i].tags_needed);
			lower_tags[belt_items[i].slot].show_all_filled(belt_items[i].tags_filled);
			lower_tags[belt_items[i].slot].visible = true;
			lower_belt_slots[belt_items[i].slot].visible = true;
		
var thisrt_class = load("res://tshirt.gd")
func add_new_tshirt(belt:int):
	var ts:Tshirt = thisrt_class.new();
	if( belt==0):
		ts.slot=4;
		ts.dir=-1;
	ts.tags_needed[randi_range(0,2)]=1;
	ts.belt=belt;
	belt_items.append(ts);

func give_random_tag():
	var allTags = [Constants.TAG.WASH, Constants.TAG.DRY, Constants.TAG.IRON];
	randomized_tag = allTags.pick_random();
	
	print("randomized_tag ",Constants.TAG.keys()[randomized_tag]);
	match randomized_tag:
		Constants.TAG.WASH:
			%RandomWash.visible=true;
		Constants.TAG.DRY:
			%RandomDry.visible=true;
		Constants.TAG.IRON:
			%RandomIron.visible=true;

func hide_all_random_tags():
	%RandomWash.visible=false;
	%RandomDry.visible=false;
	%RandomIron.visible=false;

func action_take_random_tag():
	hide_all_random_tags();
	taken_randomized_tag = randomized_tag;
	randomized_tag = Constants.TAG.NONE;
	match taken_randomized_tag:
		Constants.TAG.WASH:
			%TakenWash.visible=true;
		Constants.TAG.DRY:
			%TakenDry.visible=true;
		Constants.TAG.IRON:
			%TakenIron.visible=true;

func _on_player_action(type: Constants.ACTION) -> void:
	print("action: ",Constants.ACTION.keys()[type]);
	match type:
		Constants.ACTION.TAKE_TAG:
			action_take_random_tag();
		Constants.ACTION.TRASH:
			action_trash();
		Constants.ACTION.UP:
			action_slap_tag(0);
		Constants.ACTION.DOWN:
			action_slap_tag(1);
		Constants.ACTION.ROCKET:
			action_buildup_rocket();
			
func action_trash():
#	if(taken_randomized_tag==Constants.TAG.NONE):
#		print("no item");
#		return;
	if(trash_fill==3):
		print("trash full");
		%Trash.frame=0;
		trash_fill=0;
		return;
		
	deplete_taken_tag();
	give_random_tag();
	trash_fill+=1;
	%Trash.frame=trash_fill;
	pass;

func action_slap_tag(y_slot:int):
	if(taken_randomized_tag==Constants.TAG.NONE):
		print("no item");
		return;

	var fill_result:Constants.FILL_RESULT;
	for i in belt_items.size():
		if(belt_items[i].slot==player.x_slot):
			#check if need takend tag
			fill_result = belt_items[i].try_fill(taken_randomized_tag);
			print(Constants.FILL_RESULT.keys()[fill_result]);
			taken_randomized_tag = Constants.TAG.NONE;
			sumbit_points(fill_result);
			refresh_view_belt_slots();
			deplete_taken_tag();
			give_random_tag();
			if(y_slot==0):
				upper_player_slots[player.x_slot].frame=1;
			else:
				lower_player_slots[player.x_slot].frame=1;
			return;

func sumbit_points(res:Constants.FILL_RESULT):
	match res:
		Constants.FILL_RESULT.FILLED:
			points+=1;
		Constants.FILL_RESULT.NOT_NEEDED:
			points-=1;
	$HUD/Points.text=str(points);

func deplete_taken_tag():
	taken_randomized_tag = Constants.TAG.NONE;
	%TakenWash.visible=false;
	%TakenIron.visible=false;
	%TakenDry.visible=false;
	
func process_points(fill_result:Constants.FILL_RESULT):
	pass;

func action_buildup_rocket():
	print("buildup_rocket");
	if(points>=5):
		points -= 5;
	var r:Rocket = $HUD/Rocket;
	r.add();
	if(r.elements>=1):
		print("WIN")
		$".".get_tree().change_scene_to_file("res://win_screen.tscn")

func loose_life():
	print("loose life");
	lifes-=1;
	if(lifes<=0):
		print("GAME OVER")
		$".".get_tree().change_scene_to_file("res://gameover_screen.tscn")
#		get_node("/root/global").goto_scene("res://gameover_screen.tscn")
		#get_tree().change_scene_to_file("res://gameover_screen.tscn")

func spawn_another_tshirt():
	if(lastSpawnedBelt==0):
		lastSpawnedBelt=1;
	else:
		lastSpawnedBelt=0;
	add_new_tshirt(lastSpawnedBelt);
