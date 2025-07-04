class_name StoneGrid
extends TileMapLayer

const BLACK_STONE = preload("res://scenes/black_stone.tscn")
const WHITE_STONE = preload("res://scenes/white_stone.tscn")

const VECTOR_DIRECTIONS := [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]

const board_size := Vector2(9,9)
const cell_size := Vector2(156,156)

var cells : Dictionary[Vector2i, Stone]


func _ready() -> void:
	for x in range(board_size.x):
		for y in range(board_size.y):
			cells[Vector2i(x,y)] = null


func get_open_cells() -> Array[Vector2i]:
	var output : Array[Vector2i]
	
	for cell in cells:
		if cells[cell] == null:
			output.append(cell)
	
	return output


func get_occupied_cells() -> Array[Vector2i]:
	var output : Array[Vector2i]
	
	for cell in cells:
		if cells[cell] != null:
			output.append(cell)
	
	return output


func has_open_cell() -> bool:
	if get_open_cells().size() != 0:
		return true
	
	return false


func find_closest_cell_to_position(_position: Vector2, maximum_distance: float = INF) -> Vector2i:
	assert(has_open_cell())
	
	var output: Vector2i = Vector2i(-1,-1)
	
	for cell in get_open_cells():
		var cell_distance = abs((_position - to_global(map_to_local(cell))).length())
		var output_distance = abs((_position - to_global(map_to_local(output))).length())
		
		if cell_distance < maximum_distance and cell_distance < output_distance:
			output = cell
	
	return output

# for testing - can be removed
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test"):
		#print(local_to_map(get_local_mouse_position()))
		#print(find_group_at(local_to_map(get_local_mouse_position())))
		#print(count_liberties(find_group_at(local_to_map(get_local_mouse_position()))))
		
		print(find_all_captured_groups())


func find_group_at(cell: Vector2i) -> Array[Vector2i]:
	var output: Array[Vector2i] = [cell]
	
	if not cells.has(cell) or cells[cell] == null:
		return []
	
	while add_adjacent_cells(output, cells[cell].color) != output:
		output = add_adjacent_cells(output, cells[cell].color)
	
	output.sort()
	
	return output


func add_adjacent_cells(current_group: Array[Vector2i], stone_color: Stone.StoneColor) -> Array[Vector2i]:
	var output = current_group.duplicate(true)
	
	for cell in current_group:
		for direction in VECTOR_DIRECTIONS:
			if not cells.has(cell + direction) or cells[cell + direction] == null:
				continue
			
			if cells[cell + direction].color == stone_color and cell + direction not in output:
				output.append(cell + direction)
	
	return output


func count_liberties(group: Array[Vector2i]) -> int:
	var liberties: Array[Vector2i]
	
	for cell in group:
		for direction in VECTOR_DIRECTIONS:
			var neighbor = cell + direction
			if cells.has(neighbor) and cells[neighbor] == null and neighbor not in liberties:
				liberties.append(neighbor)
	
	return liberties.size()


func find_all_captured_groups() -> Array[Array]:
	var output: Array[Array]
	var groups = find_all_groups()
	
	for group in groups:
		if count_liberties(group) == 0:
			output.append(group)
	
	return output


func remove_group(group: Array[Vector2i]) -> void:
	for cell in group:
		remove_stone(cell)


func remove_all_captured_groups() -> void:
	for group in find_all_captured_groups():
		remove_group(group)


func remove_stone(cell: Vector2i) -> void:
	cells[cell].queue_free()
	cells[cell] = null


func find_all_groups() -> Array[Array]:
	var output: Array[Array]
	
	for cell in get_occupied_cells():
		var group = find_group_at(cell)
		if group not in output:
			output.append(group)
	
	return output


func add_stone(stone_color: Stone.StoneColor, cell: Vector2i) -> void:
	assert(cell in get_open_cells())
	
	var stone_scene
	
	match stone_color:
		Stone.StoneColor.BLACK:
			stone_scene = BLACK_STONE
		Stone.StoneColor.WHITE:
			stone_scene = WHITE_STONE
	
	var new_stone: Stone = stone_scene.instantiate()
	new_stone.position = map_to_local(cell)
	add_child(new_stone)
	
	cells[cell] = new_stone
