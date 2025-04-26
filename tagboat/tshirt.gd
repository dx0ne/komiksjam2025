class_name Tshirt;
extends Node2D

var slot:int=0;
var belt:int=0;
var tags:Array = [0,0,0];
var tags_needed:Array = [0,0,0];
var tags_filled:Array = [0,0,0];
var dir:int=1;
var marked_for_delete:bool=false;

func try_fill(tag:Constants.TAG) -> Constants.FILL_RESULT:
	var tgs_idx:int=0;
	print("try ", Constants.TAG.keys()[tag]);
	print("tags_needed ", tags_needed);
	print("tags_filled ", tags_filled);
	match tag:
		Constants.TAG.WASH:
			tgs_idx=0;
		Constants.TAG.DRY:
			tgs_idx=1;
		Constants.TAG.IRON:
			tgs_idx=2;
	if(tags_needed[tgs_idx]<=0):
		tags_needed[tgs_idx]-=1
		return Constants.FILL_RESULT.NOT_NEEDED;
	if(tags_filled[tgs_idx]==1):
		return Constants.FILL_RESULT.OVERFILLED;
	tags_filled[tgs_idx]=1;
	return Constants.FILL_RESULT.FILLED;
