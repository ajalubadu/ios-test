extends Node2D

@export var grid : StoneGrid

var current_stone_scene : PackedScene = StoneGrid.BLACK_STONE


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place stone"):
		var clicked_cell = grid.find_closest_cell_to_position(get_global_mouse_position(), 100)
		place_current_stone(clicked_cell)


func place_current_stone(cell: Vector2i):
	if cell in grid.get_open_cells():
		grid.add_stone(current_stone_scene, cell)
		grid.remove_all_captured_groups()
		
		if current_stone_scene == StoneGrid.BLACK_STONE:
			current_stone_scene = StoneGrid.WHITE_STONE
		else: 
			current_stone_scene = StoneGrid.BLACK_STONE
