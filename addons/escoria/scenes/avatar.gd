# A dialog GUI showing a dialog box and character portraits
extends Popup


# Signal emitted when text has been said
signal say_finished

# Signal emitted when text has just become fully visible
signal say_visible


# The text speed per character for normal display
var _text_time_per_character: float

# The text speed per character if the dialog line is skipped
var _fast_text_time_per_character: float

# The reading speed to be used in determining the length of time text remains
# on the screen.
var _reading_speed_in_wpm: int

# Used to extract words from lines of text.
var _word_regex: RegEx = RegEx.new()

# Whether the current dialog is speeding up
var _is_speeding_up: bool = false

# The current line of text being displayed.
var _current_line: String


# The node holding the avatar
@onready var avatar_node = $Panel/MarginContainer/HSplitContainer/VBoxContainer\
		/avatar

# The node showing the text
@onready var text_node = $Panel/MarginContainer/HSplitContainer/text

# The tween node for text animations
var tween;

# Whether the dialog manager is paused
@onready var is_paused: bool = true



# Build up the UI
func _ready():
	_text_time_per_character = ProjectSettings.get_setting(
		ESCProjectSettingsManager.SPEED_PER_C
	)

	if _text_time_per_character < 0:
		escoria.logger.warn(
			self,
			"%s setting must be a non-negative number. Will use default value of %s." %
				[
					ESCProjectSettingsManager.SPEED_PER_C,
					ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_VALUE
				]
		)

		_text_time_per_character = ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_VALUE

	_fast_text_time_per_character = ProjectSettings.get_setting(
		ESCProjectSettingsManager.FAST_TIME_C
	)

	if _fast_text_time_per_character < 0:
		escoria.logger.warn(
			self,
			"%s setting must be a non-negative number. Will use default value of %s." %
				[
					ESCProjectSettingsManager.FAST_TIME_C,
					ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_FAST_VALUE
				]
		)

		_fast_text_time_per_character = ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_FAST_VALUE

	_reading_speed_in_wpm = ProjectSettings.get_setting(
		ESCProjectSettingsManager.READING_SPEED_IN_WPM
	)

	if _reading_speed_in_wpm <= 0:
		escoria.logger.warn(
			self,
			"%s setting must be a positive number. Will use default value of %s." %
				[
					ESCProjectSettingsManager.READING_SPEED_IN_WPM,
					ESCProjectSettingsManager.READING_SPEED_IN_WPM_VALUE
				]
		)

		_reading_speed_in_wpm = ESCProjectSettingsManager.READING_SPEED_IN_WPM_VALUE

	_word_regex.compile("\\S+")

	text_node.bbcode_enabled = true
	escoria.connect("request_pause_menu", self._on_paused)
	escoria.connect("resumed", self._on_resumed)
	connect("tree_exited", self._on_tree_exited)

# Switch the current character
#
# #### Parameters
# - name: The name of the current character
func set_current_character(name: String):
	if ProjectSettings.get_setting("escoria/dialog/avatars_path").is_empty():
		escoria.logger.warn(self, "Unable to load avatar '%s': Avatar path not specified" % name)
		return

	var avatar = "%s/%s.tres" % [
		ProjectSettings.get_setting("escoria/dialog/avatars_path"),
		name
	]
	if ResourceLoader.exists(avatar):
		avatar_node.texture = ResourceLoader.load(avatar)

		if avatar_node.texture is AnimatedTexture:
			avatar_node.texture.current_frame = 0
			avatar_node.texture.pause = false
	else:
		escoria.logger.warn(self, "Unable to load avatar '%s': Resource not found in path '%s'" %
			[name, ProjectSettings.get_setting("escoria/dialog/avatars_path")])

# Make a character say something
#
# #### Parameters
# - character: The global id of the character speaking
# - line: Line to say
func say(character: String, line: String):
	_current_line = line

	_is_speeding_up = false
	popup_centered()
	set_current_character(character)

	text_node.bbcode_text = tr(line)

	text_node.visible_ratio = 1.0
	var time_show_full_text = _text_time_per_character / 1000 * len(line)

	if tween:
		tween.kill()  # elimina el tween anterior si existe

	tween = create_tween()
	tween.tween_property(text_node, "visible_ratio", 1.0, time_show_full_text).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.connect("finished",self._on_dialog_line_typed)

# Called by the dialog player when the
func speedup():
	if not _is_speeding_up:
		_is_speeding_up = true
		var time_show_full_text = _fast_text_time_per_character / 1000 * len(_current_line)
		
		if tween:
			tween.kill()  # elimina el tween anterior si existe
		
		tween = create_tween()
		tween.tween_property(text_node, "visible_ratio",	1.0,time_show_full_text).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
		tween.connect("finished",self._on_dialog_line_typed)


# Called by the dialog player when user wants to finish dialogue immediately.
func finish():
	if tween:
		tween.kill()  # elimina el tween anterior si existe
	tween = create_tween()
	tween.tween_property(text_node, "visible_ratio",	1.0, 0.0)
	tween.connect("finished",self._on_dialog_line_typed)


# To be called if voice audio has finished.
func voice_audio_finished():
	if avatar_node and avatar_node.texture:
		avatar_node.texture.current_frame = 0
		avatar_node.texture.pause = true


# The dialog line was printed, start the waiting time and then finish
# the dialog
func _on_dialog_line_typed():
	if avatar_node.texture is AnimatedTexture:
		avatar_node.texture.current_frame = 0
		avatar_node.texture.pause = true

	text_node.visible_characters = -1

	var time_to_disappear: float = _calculate_time_to_disappear()

	if not $Timer.is_connected("timeout", self._on_dialog_finished):
		$Timer.connect("timeout", self._on_dialog_finished)

	$Timer.start(time_to_disappear)

	emit_signal("say_visible")


func _calculate_time_to_disappear() -> float:
	return (_get_number_of_words() / _reading_speed_in_wpm as float) * 60

func _get_number_of_words() -> int:
	return _word_regex.search_all(text_node.get_text()).size()

# Ending the dialog
func _on_dialog_finished():
	$Timer.stop()

	# Only trigger to clear the text if we aren't limiting the clearing trigger to a click.
	if not ESCProjectSettingsManager.get_setting(ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY):
		emit_signal("say_finished")

# Handler managing pause notification from Escoria
func _on_paused():
	if tween and tween.is_running():
		is_paused = true
		tween.kill()

# Handler managing resume notification from Escoria
func _on_resumed():
	if tween and tween.is_running():
		is_paused = true
		tween.kill()


func _on_tree_exited():
	queue_free()
