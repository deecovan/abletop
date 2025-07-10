extends Node2D

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_SLOT = 2

const DEFAULT_CARD_ZOOM_SPEED = 0.1
const DEFAULT_CARD_MOVE_SPEED = 0.2
const DEFAULT_CARD_PICK_SPEED = 0.4
const DEFAULT_CARD_Y_OFFSET = 100

const ZOOM_NORMAL = Vector2(0.5,0.5)
const ZOOM_IN = Vector2(0.55,0.55)

const MAX_CARD_IN_HAND = 10
const STARTING_HAND_SIZE = 4

var screen_size
var card_being_dragged
var is_hovering_on_card
var player_hand_reference

func _ready() -> void:
	screen_size = get_viewport().size
	player_hand_reference =  $"../PlayerHand"
	$"../InputManager".connect("left_mouse_button_released", on_left_click_released)
	
func _process(_delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(
			lerp(card_being_dragged.position.x, clamp(mouse_pos.x, 0, screen_size.x), DEFAULT_CARD_PICK_SPEED),
			lerp(card_being_dragged.position.y, clamp(mouse_pos.y, 0, screen_size.y), DEFAULT_CARD_PICK_SPEED))
			
func card_clicked(card) -> void:
	#printt("card_clicked", str(card.name))
	if card.card_slot_card_is_in:
		var opponent_cards_on_battlefield: Array = $"../BattleManager".opponent_cards_on_battlefield
		var opponent_card_to_attack = opponent_cards_on_battlefield.pick_random()
		print(opponent_cards_on_battlefield)
		if opponent_card_to_attack:
			$"../BattleManager".attack(card, opponent_card_to_attack, "Player")
	else:
		start_drag(card)

func start_drag(card) -> void:
	card_being_dragged = card
	card.starting_position = card.position
	var tween = get_tree().create_tween()
	tween.tween_property(card, "scale", ZOOM_IN, DEFAULT_CARD_ZOOM_SPEED)
	card.z_index = 4
	
func finish_drag() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(card_being_dragged, "scale", ZOOM_NORMAL, DEFAULT_CARD_ZOOM_SPEED)
	var card_slot_found = raycast_check_for_card_slot()
	if card_slot_found and not card_slot_found.card_in_slot:
		player_hand_reference.remove_card_from_hand(card_being_dragged)
		card_being_dragged.position = card_slot_found.position
		card_slot_found.card_in_slot = true
		card_being_dragged.card_slot_card_is_in = card_slot_found
		$"../BattleManager".player_cards_on_battlefield.append(card_being_dragged)
	else:
		player_hand_reference.add_card_to_hand(card_being_dragged)
	card_being_dragged.z_index = 3
	card_being_dragged = null
	
func connect_card_signals(card) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
		
func on_left_click_released() -> void:
	if card_being_dragged:
		finish_drag()

func on_hovered_over_card(card) -> void:
	if !is_hovering_on_card:
		is_hovering_on_card =  true
		highlight_card(card, true)

func on_hovered_off_card(card) -> void:
	if !card_being_dragged:
		highlight_card(card, false)
		is_hovering_on_card = false
		var new_card_hovered = raycast_check_for_card()
		if new_card_hovered:
			is_hovering_on_card = true
			highlight_card(new_card_hovered, true)
	
func highlight_card(card, hovered) -> void:
	if hovered:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "scale", ZOOM_IN, DEFAULT_CARD_ZOOM_SPEED)
		card.z_index = 2
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(card, "scale", ZOOM_NORMAL, DEFAULT_CARD_ZOOM_SPEED)
		card.z_index = 1
	
func raycast_check_for_card_slot() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true;
	parameters.collision_mask = COLLISION_MASK_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	return null

func raycast_check_for_card() -> Node2D:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true;
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return get_card_with_highest_z_index(result)
	return null
	
func get_card_with_highest_z_index(cards) -> Node2D:
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_index = current_card.z_index
			highest_z_card = current_card
	return highest_z_card
	
	
	
