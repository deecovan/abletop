extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var player_deck = [
	"Wall",
	"Wall",
	"Water",
	"Water",
	"Peasant",
	"Peasant",
	"Peasant",
	"Peasant",
	"Sergant",
	"Sergant",
	"Knight",
	"Tank",
	"Pikiner",
	"Pikiner",
	"Pikiner",
	"Pikiner",
	"Ranger",
	"Ranger",
	"Archer",
	"Mage",
]

func _ready() -> void:
	## Double deck
	player_deck += player_deck
	player_deck.shuffle()
	$CardsInDeck.text = str(player_deck.size())
	for i in range($"../CardManager".STARTING_HAND_SIZE):
		draw_card()
	
func draw_card() -> void:
	# Break if maximum cards drawn
	var player_hand = $"../PlayerHand".player_hand
	if player_hand.size() == $"../CardManager".MAX_CARD_IN_HAND:
		return
		
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$CardsInDeck.visible = false
		
	$CardsInDeck.text = str(player_deck.size())
	var new_card = card_scene.instantiate()
	new_card.position = Vector2(position.x, position.y)
	new_card.get_node("CardImage").texture = load("res://Assets/" + str(card_drawn_name) + ".png")
	new_card.get_node("Name").text = card_drawn_name
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	new_card.attack = card_database_reference.CARDS[card_drawn_name][0]
	new_card.health = card_database_reference.CARDS[card_drawn_name][1]
	$"../CardManager".add_child(new_card)
	new_card.name = card_drawn_name + "_" + str(new_card.get_parent().get_index())
	## @DEBUG
	# printt("new_card.name",new_card.name)
	$"../PlayerHand".add_card_to_hand(new_card)
	new_card.get_node("AnimationPlayer").play("Flip")
	
	# Message if maximum cards drawn
	if player_hand.size() == $"../CardManager".MAX_CARD_IN_HAND:
		$"../BattleManager/RichTextLabel".text = \
		"Can draw maximum " + str($"../CardManager".MAX_CARD_IN_HAND) + " cards!"
		$"../BattleManager/RichTextLabel".visible = true
		await $"../BattleManager".battle_timer(5000)
		$"../BattleManager/RichTextLabel".visible = false

func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
