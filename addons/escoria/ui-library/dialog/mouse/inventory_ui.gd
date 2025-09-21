extends ESCInventory


# Whether the inventory is visible currently
var inventory_visible: bool = false

var tween

func _ready() -> void:
	# Hide inventory by default
	$FloatingInventory/panel.rect_position.x = \
		ProjectSettings.get_setting("display/window/size/viewport_width")
	tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	

func _on_inventory_button_pressed():
	if tween and tween.is_running():
		return
	if inventory_visible:
		hide_inventory()
	else:
		show_inventory()


func show_inventory():
	if tween:
		tween.kill()  # Detener tween anterior si existe

	var panel = $FloatingInventory/panel
	var button = $HBoxContainer/inventory_button
	var target_x = panel.position.x - panel.size.x - button.size.x

	tween = create_tween()
	tween.tween_property(panel, "position:x", target_x, 0.6)

	await tween.finished
	inventory_visible = true


func hide_inventory():
	if tween:
		tween.kill()

	var panel = $FloatingInventory/panel
	var button = $HBoxContainer/inventory_button
	var target_x = panel.position.x + panel.size.x + button.size.x

	tween = create_tween()
	tween.tween_property(panel, "position:x", target_x, 0.6)

	await tween.finished
	inventory_visible = false
