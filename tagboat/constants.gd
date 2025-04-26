class_name Constants
extends Node

enum TAG {
	NONE,
	WASH,
	DRY,
	IRON
}

static func get_random_tag() -> Constants.TAG:
	var allTags = [Constants.TAG.WASH, Constants.TAG.DRY, Constants.TAG.IRON];
	return allTags.pick_random();

enum ACTION {
	TAKE_TAG,
	UP,
	DOWN,
	ROCKET,
	TRASH
}

enum FILL_RESULT {
	FILLED,
	OVERFILLED,
	NOT_NEEDED
}
