extends Node2D

@export var grid : StoneGrid

var current_stone_color : Stone.StoneColor = Stone.StoneColor.BLACK
var ko_cell : Vector2i = Vector2i(-1,-1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("place stone"):
		var clicked_cell = grid.find_closest_cell_to_position(get_global_mouse_position(), 100)
		place_current_stone(clicked_cell)


func place_current_stone(cell: Vector2i) -> void:
	if cell in grid.get_open_cells():
		grid.add_stone(current_stone_color, cell)
		
		var captured_groups = grid.find_all_captured_groups()
		
		var enemy_captured_groups: Array[Array] = []
		var self_captured_groups: Array[Array] = []
		
		for group in captured_groups:
			if grid.cells[group[0]].color != current_stone_color:
				enemy_captured_groups.append(group)
			else:
				self_captured_groups.append(group)
		
		# ko
		if cell == ko_cell:
			grid.remove_stone(cell)
			return
		if self_captured_groups.size() == 1 and enemy_captured_groups.size() == 1 and enemy_captured_groups[0].size() == 1:
			ko_cell = enemy_captured_groups[0][0]
		else:
			ko_cell = Vector2i(-1, -1)
		
		# normal capture
		if enemy_captured_groups.size() > 0 and self_captured_groups.size() == 0:
			for group in enemy_captured_groups:
				grid.remove_group(group)
		
		# illegal self capture
		if enemy_captured_groups.size() == 0 and self_captured_groups.size() > 0:
			grid.remove_stone(cell)
			return
		
		# capture by placing in eye
		if self_captured_groups.size() > 0 and enemy_captured_groups.size() > 0:
			for group in enemy_captured_groups:
				grid.remove_group(group)
		
		if current_stone_color == Stone.StoneColor.BLACK:
			current_stone_color = Stone.StoneColor.WHITE
		else: 
			current_stone_color = Stone.StoneColor.BLACK
