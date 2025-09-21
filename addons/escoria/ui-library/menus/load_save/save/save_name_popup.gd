extends Popup

signal savegame_name_ok(savegame_name)
signal savegame_cancel

func _on_cancel_pressed():
	emit_signal("savegame_cancel")
	hide()

func _on_ok_pressed():
	if not $MarginContainer/VBoxContainer/LineEdit.text.is_empty():
		emit_signal("savegame_name_ok", $MarginContainer/VBoxContainer/LineEdit.text)
		$MarginContainer/VBoxContainer/LineEdit.clear()
		hide()

func _input(event):
	if event is InputEventKey:
		if event.is_pressed() and event.key_label == KEY_ENTER or event.key_label == KEY_KP_ENTER:
			_on_ok_pressed()
