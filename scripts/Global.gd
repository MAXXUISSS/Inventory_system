extends Node
var inventory = []

#Custom Signals
signal inventory_updated
var spawnable_items = [
	{"type": "Consumable", "name" : "Berry", "effect" : "health", "texture": preload("res://Assets/Icons/icon31.png")},
	{"type": "Consumable", "name" : "Water", "effect" : "Stamina", "texture": preload("res://Assets/Icons/icon9.png")},
	{"type": "Consumable", "name" : "Mushroom", "effect" : "armor", "texture": preload("res://Assets/Icons/icon32.png")},
	{"type": "Gift", "name" : "Gemstone", "effect" : "", "texture": preload("res://Assets/Icons/icon21.png")}
]

#References
var player_node: Node = null
@onready var inventory_slot_scene = preload("res://scenes/inventory_slot.tscn")

func _ready():
	inventory.resize(10)

#Add item to inventory, return true if sucessfull
func add_item(item):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			return true
	return false  

	
#Remove item from the inventory based on type and effect
func remove_item(item_type,item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
	
#Increase inventory size dynamically
func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
	print("referencia del jugador establecida: ", player_node)

func adjust_drop_position(position):
	var radius = 50
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius,radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position
	
func drop_item(item_data,drop_position):
	var item_scene = load(item_data["scene_path"])
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
	
