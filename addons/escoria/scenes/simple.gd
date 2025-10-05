# A simple dialog chooser that shows selectable lines of text
# Supports timeout and avatar display
extends ESCDialogOptionsChooser

@export var color_normal = Color(1.0,1.0,1.0,1.0)
@export var color_hover = Color(165.0,42.0,42.0, 1.0)


var _no_more_options: bool = false

# Hide the chooser at the start just to be safe
func _ready() -> void:
	hide_chooser()
	self.process_mode = PROCESS_MODE_DISABLED


# Process the timeout display
func _process(delta: float) -> void:
	if $MarginContainer.visible and self.dialog and self.dialog.timeout > 0:
		$TimerProgress.value = (
			self.dialog.timeout - $Timer.time_left
		) / self.dialog.timeout * 100


# Show the chooser
func show_chooser():
	var _vbox = $MarginContainer/ScrollContainer/VBoxContainer
	for option_node in _vbox.get_children():
		_vbox.remove_child(option_node)
	_remove_avatar()
	for option in self.dialog.options:
		if option.is_valid():
			var _option_node = Button.new()
			_option_node.text = (option as ESCDialogOption).option
			_option_node.flat = true
			_option_node.add_theme_color_override("font_color", color_normal)
			_option_node.add_theme_color_override("font_color_hover", color_hover)
			_option_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			_option_node.size_flags_vertical = Control.SIZE_SHRINK_CENTER
			_option_node.size = Vector2(165, 40)
			_option_node.focus_mode = Control.FOCUS_ALL
			_option_node.mouse_filter = Control.MOUSE_FILTER_STOP
			_option_node.mouse_force_pass_scroll_events = true
			_option_node.button_mask = MOUSE_BUTTON_MASK_LEFT
			_option_node.action_mode = BaseButton.ACTION_MODE_BUTTON_PRESS
			_option_node.set_process_input(true)
			_option_node.process_mode = Node.PROCESS_MODE_ALWAYS
			_option_node.z_index = 100
			_vbox.add_child(_option_node)
			_option_node.pressed.connect(self._on_answer_selected.bind((option as ESCDialogOption)))
	if _vbox.get_child_count() == 0:
		_no_more_options = true
		$Timer.start(0.05)
		return
	if _vbox.get_child_count() > 0:
		_vbox.get_child(0).grab_focus()
	if self.dialog.avatar != "-":
		$AvatarContainer.add_child(
			ResourceLoader.load(self.dialog.avatar).instantiate())
	$MarginContainer.show()
	if self.dialog.timeout > 0:
		$Timer.start(self.dialog.timeout)

	
# Hide the chooser
func hide_chooser():
	$MarginContainer.hide()


# An option was choosen, emit the option
#
# #### Parameters
# - option: Option that was chosen
func _option_chosen(option: ESCDialogOption):
	_remove_avatar()
	$TimerProgress.value = 0
	emit_signal("option_chosen", option)


# An option was chosen directly from the list
#
# #### Parameters
# - option: Option that was chosen
func _on_answer_selected(option: ESCDialogOption):
	_option_chosen(option)


# The timeout came and a option was selected
func _on_Timer_timeout() -> void:
	var option_chosen = null if _no_more_options else self.dialog.options[self.dialog.timeout_option - 1]
	_no_more_options = false
	_option_chosen(option_chosen)


# Remove the avatar
func _remove_avatar():
	if $AvatarContainer.get_child_count() > 0:
		$AvatarContainer.remove_child($AvatarContainer.get_child(0))
