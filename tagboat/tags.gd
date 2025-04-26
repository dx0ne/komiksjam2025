class_name Tags
extends Node2D

func _ready() -> void:
	hide_all();
	
func hide_all():
	$LaundryIconWash.visible=false;
	$LaundryIconDry.visible=false;
	$LaundryIconIron.visible=false;
	$LaundryIconWash2.visible=false;
	$LaundryIconDry2.visible=false;
	$LaundryIconIron2.visible=false;

func show_needed(tag:Constants.TAG):
	match tag:
		Constants.TAG.WASH:
			$LaundryIconWash.visible=true;
		Constants.TAG.DRY:
			$LaundryIconDry.visible=true;
		Constants.TAG.IRON:
			$LaundryIconIron.visible=true;

func show_filled(tag:Constants.TAG):
	match tag:
		Constants.TAG.WASH:
			$LaundryIconWash.visible=true;
		Constants.TAG.DRY:
			$LaundryIconDry.visible=true;
		Constants.TAG.IRON:
			$LaundryIconIron.visible=true;
			
func show_all_needed(ar:Array):
	if(ar[0]==1):
		show_needed(Constants.TAG.WASH);
	if(ar[1]==1):
		show_needed(Constants.TAG.DRY);
	if(ar[2]==1):
		show_needed(Constants.TAG.IRON);

func show_all_filled(ar:Array):
	if(ar[0]==1):
		show_filled(Constants.TAG.WASH);
	if(ar[1]==1):
		show_filled(Constants.TAG.DRY);
	if(ar[2]==1):
		show_filled(Constants.TAG.IRON);
