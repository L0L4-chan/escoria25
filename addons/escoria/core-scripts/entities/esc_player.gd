# A playable character
@tool
@icon( "res://addons/escoria/assets/image/esc_player.svg")
extends ESCItem
class_name ESCPlayer




# Whether the player can be selected like an item
@export var selectable = false


# A player is always movable
func _init():
	is_movable = true
	_force_registration = true


# Ready function
func _ready():
	super._ready()
	if !selectable:
		tooltip_name = ""
