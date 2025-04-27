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

func score() -> int:
	var sumScore:int=0;
	sumScore+=part_score(0);
	sumScore+=part_score(1);
	sumScore+=part_score(2);
	return sumScore;

func part_score(i:int=0) -> int:
	var ret:int=0;
	if(tags_needed[i]==1 and tags_filled[i]==1):
		return 1;
	if(tags_needed[i]<0):
		return tags_needed[i];
	return 0;

func is_fully_filled() -> bool:
	if(tags_needed[0]==1 and tags_filled[0]==0):
		return false;
	if(tags_needed[1]==1 and tags_filled[1]==0):
		return false;
	if(tags_needed[2]==1 and tags_filled[2]==0):
		return false;
	print("all good ",tags_needed," ",tags_filled)
	return true;

func give_unfilled() -> Constants.TAG:
	if(tags_needed[0]==1 and tags_filled[0]==0):
		return Constants.TAG.WASH;
	if(tags_needed[1]==1 and tags_filled[1]==0):
		return Constants.TAG.DRY;
	if(tags_needed[2]==1 and tags_filled[2]==0):
		return Constants.TAG.IRON;
	return Constants.TAG.NONE;
