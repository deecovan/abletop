extends Node2D

var card_scene = preload("res://Scenes/Card.tscn")
var card_database_reference = preload("res://Scripts/CardDatabase.gd")
var player_deck = [
	"Knight", "Archer", "Mage", "Knight",
	"Knight", "Archer", "Mage", "Knight",
]

func _ready() -> void:
	player_deck.shuffle()
	$CardsInDeck.text = str(player_deck.size())
	
	for i in range($"../BattleManager".STARTING_HAND_SIZE):
		draw_card()
	
func draw_card() -> void:
	var card_drawn_name = player_deck[0]
	player_deck.erase(card_drawn_name)
	
	if player_deck.size() == 0:
		$Area2D/CollisionShape2D.disabled = true
		$Sprite2D.visible = false
		$CardsInDeck.visible = false
		
	$CardsInDeck.text = str(player_deck.size())
	var new_card = card_scene.instantiate()
	new_card.name = "Card"
	new_card.position = Vector2(position.x, position.y)
	new_card.get_node("CardImage").texture = load("res://Assets/" + card_drawn_name + ".png")
	new_card.get_node("Attack").text = str(card_database_reference.CARDS[card_drawn_name][0])
	new_card.get_node("Health").text = str(card_database_reference.CARDS[card_drawn_name][1])
	$"../CardManager".add_child(new_card)
	$"../PlayerHand".add_card_to_hand(new_card)
	new_card.get_node("AnimationPlayer").play("Flip")


func _on_area_2d_mouse_entered() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _on_area_2d_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
