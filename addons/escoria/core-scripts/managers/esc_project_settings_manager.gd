# Registers and allows access to Escoria-specific project settings.
extends Resource
class_name ESCProjectSettingsManager


const _ESCORIA_SETTINGS_ROOT = "escoria"

const _UI_ROOT = "ui"

const DEFAULT_DIALOG_TYPE = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/default_dialog_type"
const DEFAULT_DIALOG_SCENE = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/default_dialog_scene"
const DIALOG_CHOOSER = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/dialog_chooser"
const DEFAULT_TRANSITION =_ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/default_transition" 
const DIALOG_MANAGERS = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/dialog_managers" 
const GAME_SCENE = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/game_ui"
const INVENTORY_ITEM_SIZE = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/inventory_item_size" 
const INVENTORY_ITEMS_PATH =_ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/inventory_items_path" 
const TRANSITION_PATHS =_ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "/transition_paths"
const UI_SCRIPT = _ESCORIA_SETTINGS_ROOT+ "/" + _UI_ROOT + "active_ui_script_path"

# Main Escoria project settings
const _MAIN_ROOT = "main"

const COMMAND_DIRECTORIES = _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/command_directories" 
const FORCE_QUIT =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/force_quit" 
const GAME_VERSION =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/game_version"
const GAME_START_SCRIPT =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/game_start_script" 
const ACTION_DEFAULT_SCRIPT =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/action_default_script" 
const SAVEGAMES_PATH =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/savegames_path" 
const SETTINGS_PATH = _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/settings_path" 
const TEXT_LANG =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/text_lang"
const VOICE_LANG =  _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT + "/voice_lang" 
const GAME_MIGRATION_PATH = _ESCORIA_SETTINGS_ROOT+ "/" + _MAIN_ROOT +"/game_migration_path" 

#Dialod project setting
const DIALOG = "dialog"

const FAST_TIME_C = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/fast_text_speed_per_character"
const SPEED_PER_C = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/text_speed_per_character"
const AVATAR = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG +"/avatars_path"
const CLEAR_TEXT_BY_CLICK_ONLY = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/clear_text_by_click_only" 
const LEFT_CLICK_ACTION = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/left_click_action" 
const STOP_TALKING_ANIMATION_ON = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/stop_talking_animation_on"
const TEXT_TIME_PER_LETTER_MS = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/text_time_per_letter_ms" 
const TEXT_TIME_PER_LETTER_MS_FAST = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/text_time_per_fast_letter_ms" 
const READING_SPEED_IN_WPM = _ESCORIA_SETTINGS_ROOT + "/" + DIALOG + "/reading_speed_in_wpm" 

# Debug-related Escoria project settings
const _DEBUG_ROOT = "debug"

const CRASH_MESSAGE =  _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/crash_message" 
const DEVELOPMENT_LANG = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/development_lang" 
# If enabled, displays the room selection box for quick room change
const ENABLE_ROOM_SELECTOR = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/enable_room_selector" 
const LOG_FILE_PATH = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/log_file_path" 
const LOG_LEVEL = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/log_level" 
const ROOM_SELECTOR_ROOM_DIR = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/room_selector_room_dir" 
const TERMINATE_ON_ERRORS = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/terminate_on_errors" 
const TERMINATE_ON_WARNINGS = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/terminate_on_warnings"
# If enabled, displays the hover stack on screen
const ENABLE_HOVER_STACK_VIEWER = _ESCORIA_SETTINGS_ROOT+ "/" + _DEBUG_ROOT + "/enable_hover_stack_viewer"

# Sound-related Escoria project settings
const _SOUND_ROOT = "sound"

const MASTER_VOLUME =_ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/master_volume"
const MUSIC_VOLUME = _ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/music_volume"
const SFX_VOLUME = _ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/sfx_volume" 
const SPEECH_ENABLED = _ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/speech_enabled"
const SPEECH_EXTENSION = _ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/speech_extension" 
const SPEECH_FOLDER = _ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/speech_folder" 
const SPEECH_VOLUME =_ESCORIA_SETTINGS_ROOT+ "/" + _SOUND_ROOT + "/speech_volume" 

# Platform-related Escoria project settings
const _PLATFORM_ROOT = "platform"

const SKIP_CACHE = _ESCORIA_SETTINGS_ROOT+ "/" + _PLATFORM_ROOT + "/skip_cache" 
const SKIP_CACHE_MOBILE = _ESCORIA_SETTINGS_ROOT+ "/" + _PLATFORM_ROOT + "/skip_cache.mobile"

# Godot Windows project settings
const FULLSCREEN =  "display/window/size/mode"

#DIALOG SIMPLE CONS
const TEXT_TIME_PER_LETTER_MS_VALUE = 100 
const TEXT_TIME_PER_LETTER_MS_FAST_VALUE = 25
const READING_SPEED_IN_WPM_VALUE = 200
const TEXT_TIME_PER_CHARACTER_VALUE = 0.1
const TEXT_TIME_PER_CHARACTER_FAST_VALUE = .25
const LEFT_CLICK_ACTION_SPEED_UP = "Speed up"
const LEFT_CLICK_ACTION_INSTANT_FINISH = "Instant finish"
const LEFT_CLICK_ACTION_NOTHING = "None"
const STOP_TALKING_ANIMATION_ON_END_OF_TEXT = "End of text"
const STOP_TALKING_ANIMATION_ON_END_OF_AUDIO = "End of audio"

const left_click_actions: PackedStringArray = [
	LEFT_CLICK_ACTION_SPEED_UP,
	LEFT_CLICK_ACTION_INSTANT_FINISH,
	LEFT_CLICK_ACTION_NOTHING
]
const stop_talking_animation_on_options: PackedStringArray = [
	STOP_TALKING_ANIMATION_ON_END_OF_TEXT,
	STOP_TALKING_ANIMATION_ON_END_OF_AUDIO
]


# Removes the specified project setting.
#
# #### Parameters
#
# - name: Name of the project setting
static func remove_setting(name: String) -> void:
	if not ProjectSettings.has_setting(name):
		push_error("Cannot remove project setting %s - it does not exist." % name)
		assert(false)
	ProjectSettings.set_setting(
			name,
			null
		)


# Retrieves the specified project setting.
#
# #### Parameters
#
# - key: Project setting name.
#
# *Returns* the value of the project setting located with key.
static func get_setting(key: String):
	if not ProjectSettings.has_setting(key):
		push_error("Parameter %s is not set!" % key)
		assert(false)

	return ProjectSettings.get_setting(key)


# Sets the specified project setting to the provided value.
#
# #### Parameters
#
# - key: Project setting name.
# - value: Project setting value.
static func set_setting(key: String, value) -> void:
	ProjectSettings.set_setting(key, value)


# Simple wrapper for consistency's sake.
#
# #### Parameters
#
# - key: Project setting name.
#
# *Returns* true iff the project setting exists.
static func has_setting(key: String) -> bool:
	return ProjectSettings.has_setting(key)


static func set_default_values():
	set_setting(MASTER_VOLUME, 1.0)
	set_setting(MUSIC_VOLUME, 0.8)
	set_setting(SFX_VOLUME, 0.8)
	set_setting(SPEECH_VOLUME, 0.9)
	set_setting(FORCE_QUIT, false)
	set_setting(FULLSCREEN,DisplayServer.WindowMode.WINDOW_MODE_WINDOWED )
	set_setting(DEFAULT_DIALOG_TYPE,"" )
	set_setting(DEFAULT_TRANSITION, "curtain" )
	set_setting(UI_SCRIPT, "res://addons/escoria/ui-library/dialog/9-verb/game.gd")
	set_setting(GAME_SCENE, "9verbs")
	set_setting(INVENTORY_ITEMS_PATH, "res://game/items/inventory")
	set_setting(INVENTORY_ITEM_SIZE, Vector2(72, 72))
	set_setting(TRANSITION_PATHS, ["res://addons/escoria/scenes/transitions/"])
	set_setting(COMMAND_DIRECTORIES, ["res://addons/escoria/core-scripts/esc/commands/"])
	set_setting(FORCE_QUIT, true)
	set_setting(GAME_VERSION, "")
	set_setting(GAME_START_SCRIPT, "")
	set_setting(ACTION_DEFAULT_SCRIPT, "")
	set_setting(TEXT_LANG, TranslationServer.get_locale())
	set_setting(VOICE_LANG, TranslationServer.get_locale())
	set_setting(FAST_TIME_C,  TEXT_TIME_PER_CHARACTER_FAST_VALUE)
	set_setting(SPEED_PER_C, TEXT_TIME_PER_CHARACTER_VALUE )
	set_setting(AVATAR, "res://addons/escoria/scenes/avatar.tscn" )
	set_setting(CLEAR_TEXT_BY_CLICK_ONLY, true)
	set_setting(LEFT_CLICK_ACTION, LEFT_CLICK_ACTION_SPEED_UP)
	set_setting(STOP_TALKING_ANIMATION_ON,STOP_TALKING_ANIMATION_ON_END_OF_AUDIO)
	set_setting(TEXT_TIME_PER_LETTER_MS, TEXT_TIME_PER_LETTER_MS_FAST_VALUE)
	set_setting(TEXT_TIME_PER_LETTER_MS_FAST,  TEXT_TIME_PER_LETTER_MS_FAST_VALUE )
	set_setting(READING_SPEED_IN_WPM, READING_SPEED_IN_WPM_VALUE)
	set_setting(CRASH_MESSAGE, "We're sorry, but the game crashed. Please send us the following files:\n\n%s")
	set_setting(DEVELOPMENT_LANG, "en")
	set_setting(ENABLE_HOVER_STACK_VIEWER, false)
	set_setting(ENABLE_ROOM_SELECTOR, false)
	set_setting(LOG_FILE_PATH, "res://saves/log/")
	set_setting(LOG_LEVEL, "ERROR")
	set_setting(TERMINATE_ON_ERRORS, true)
	set_setting(ROOM_SELECTOR_ROOM_DIR, "")
	set_setting(TERMINATE_ON_WARNINGS, false)
	set_setting(SKIP_CACHE, false)
	set_setting(SKIP_CACHE_MOBILE, true)
