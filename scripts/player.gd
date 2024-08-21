extends CharacterBody2D


var SPEED = 200.0
@onready var sprite_face = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI

func _ready():
	Global.set_player_reference(self)

func get_input():
	var input_direction = Input.get_vector("left","right","up","down")
	velocity = input_direction * SPEED
func _physics_process(delta):
	get_input()
	move_and_slide()
	sprite_check()

func sprite_check():
	if velocity == Vector2.ZERO:
		sprite_face.play("idle")
	else:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				sprite_face.play("walk_right")
			else:
				sprite_face.play("walk_left")
		else:
			if velocity.y > 0:
				sprite_face.play("walk_down")
			else:
				sprite_face.play("walk_up")
				

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused

func apply_item_effect(item):
	match item["effect"]:
		"stamina":
			SPEED += 50
			print("Speed increased to ", SPEED)
		"Sloot Boost":
			Global.increase_inventory_size(5)
		_:
			print("there is no effect with this item")
			
