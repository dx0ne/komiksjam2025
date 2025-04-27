extends Node2D

func _input(event: InputEvent) -> void:
	if(event.is_action_released("go_down")):
		$".".get_tree().change_scene_to_file("res://main_level.tscn")
