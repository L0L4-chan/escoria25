# Plugin script to initialize Escoria
@tool
extends EditorPlugin

# The warning popup displayed on escoria enabling.
var popup_info: AcceptDialog
# Autoloads to instantiate

const autoloads = {
	"escoria": "res://addons/escoria/scenes/esc_autoload.gd",
}

func _enter_tree() -> void:
	for key in autoloads.keys():
		add_autoload_singleton(key, autoloads[key])

# Setup Escoria
func _enable_plugin() -> void:	
	# Prepare settings
	set_escoria_main_settings()
	set_escoria_debug_settings()
	set_escoria_ui_settings()
	set_escoria_sound_settings()
	set_escoria_platform_settings()
	set_escoria_dialog_manager_settings()
	
	call_deferred("_show_info_popup")
	
	
func _show_info_popup():	
	popup_info = AcceptDialog.new()
	popup_info.dialog_text = """You enabled escoria plugin.

	Please ignore error messages in Output console and reload your project using
	Godot editor's "Project / Reload Current Project" menu.
	"""
	
	popup_info.connect("confirmed", self._on_warning_popup_confirmed)
	add_child(popup_info)
	popup_info.popup_centered()

# Pop up to vanish
func _on_warning_popup_confirmed():
	popup_info.queue_free()

# Prepare the settings in the Escoria main category
func set_escoria_main_settings():
	
	if !ProjectSettings.has_setting("application/run/main_scene"):
		ProjectSettings.set_setting("application/run/main_scene", "res://addons/escoria/scenes/escoria.tscn")
		ProjectSettings.add_property_info({
			"name": "application/run/main_scene",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.tscn",
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.GAME_START_SCRIPT):
		ProjectSettings.set_setting(ESCProjectSettingsManager.GAME_START_SCRIPT, "")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.GAME_START_SCRIPT,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.esc",
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.COMMAND_DIRECTORIES):
		ProjectSettings.set_setting(ESCProjectSettingsManager.COMMAND_DIRECTORIES, [
			"res://addons/escoria/core-scripts/esc/commands/"
		])
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.COMMAND_DIRECTORIES,
			"type": TYPE_ARRAY,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SAVEGAMES_PATH):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SAVEGAMES_PATH, "res://saves/")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SAVEGAMES_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SETTINGS_PATH):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SETTINGS_PATH, "res://")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SETTINGS_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TEXT_LANG):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TEXT_LANG, TranslationServer.get_locale())
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TEXT_LANG,
			"type": TYPE_STRING,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.VOICE_LANG):
		ProjectSettings.set_setting(ESCProjectSettingsManager.VOICE_LANG, TranslationServer.get_locale())
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.VOICE_LANG,
			"type": TYPE_STRING,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.GAME_VERSION):
		ProjectSettings.set_setting(ESCProjectSettingsManager.GAME_VERSION, "")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.GAME_VERSION,
			"type": TYPE_STRING,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.FORCE_QUIT):
		ProjectSettings.set_setting(ESCProjectSettingsManager.FORCE_QUIT, true)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.FORCE_QUIT,
			"type": TYPE_BOOL,
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT):
		ProjectSettings.set_setting(ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT, "")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.esc"
		})

# Prepare the settings in the Escoria debug category
func set_escoria_debug_settings():
	# Should the game terminate immediately on warnings? Useful during development to catch issues early.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TERMINATE_ON_WARNINGS):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TERMINATE_ON_WARNINGS, false)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TERMINATE_ON_WARNINGS,
			"type": TYPE_BOOL,
			"hint": PROPERTY_HINT_NONE,
		})

	# Should the game terminate immediately on errors? Usually enabled for development.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TERMINATE_ON_ERRORS):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TERMINATE_ON_ERRORS, true)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TERMINATE_ON_ERRORS,
			"type": TYPE_BOOL,
		})

	# Primary language the game is developed in, for translation and localization purposes.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.DEVELOPMENT_LANG):
		ProjectSettings.set_setting(ESCProjectSettingsManager.DEVELOPMENT_LANG, "en")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.DEVELOPMENT_LANG,
			"type": TYPE_STRING,
		})

	# Log level to control verbosity: ERROR, WARNING, INFO, DEBUG
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.LOG_LEVEL):
		ProjectSettings.set_setting(ESCProjectSettingsManager.LOG_LEVEL, "ERROR")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.LOG_LEVEL,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "ERROR,WARNING,INFO,DEBUG",
		})

	# Path where log files will be saved. Defaults to res:// (Godot res data folder)
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.LOG_FILE_PATH):
		ProjectSettings.set_setting(ESCProjectSettingsManager.LOG_FILE_PATH, "res://")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.LOG_FILE_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	# Message shown when the game crashes. Can include instructions to send crash reports.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.CRASH_MESSAGE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.CRASH_MESSAGE, 
			"We're sorry, but the game crashed. Please send us the following files:\n\n%s"
		)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.CRASH_MESSAGE,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_MULTILINE_TEXT,
		})

	# Enable a debug UI element to select rooms/scenes at runtime.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.ENABLE_ROOM_SELECTOR):
		ProjectSettings.set_setting(ESCProjectSettingsManager.ENABLE_ROOM_SELECTOR, false)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.ENABLE_ROOM_SELECTOR,
			"type": TYPE_BOOL,
		})

	# Directory where room selector will look for scenes.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.ROOM_SELECTOR_ROOM_DIR):
		ProjectSettings.set_setting(ESCProjectSettingsManager.ROOM_SELECTOR_ROOM_DIR, "")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.ROOM_SELECTOR_ROOM_DIR,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	# Enable a stack trace viewer shown on hover for easier debugging.
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.ENABLE_HOVER_STACK_VIEWER):
		ProjectSettings.set_setting(ESCProjectSettingsManager.ENABLE_HOVER_STACK_VIEWER, false)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.ENABLE_HOVER_STACK_VIEWER,
			"type": TYPE_BOOL,
		})

# Prepare the settingd in the Escoria Ui category
func set_escoria_ui_settings():
	# Audio bus layout for game sound mixing
	ProjectSettings.set_setting("audio/default_bus_layout", "res://addons/sound/default_bus_layout.tres")
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE, "")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE,
			"type": TYPE_STRING,
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.GAME_SCENE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.GAME_SCENE, "9verbs")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.GAME_SCENE,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": "keyboard,mouse,9verbs",
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint_tooltip": "Select the type of UI input"
		})
	
	# Type of game Ui
	var ui_type = ProjectSettings.get_setting(ESCProjectSettingsManager.GAME_SCENE)
	var ui_path = ""
	match ui_type:
		"keyboard":
			ui_path = "res://addons/escoria/ui-library/dialog/keyboard/game.gd"
		"mouse":
			ui_path = "res://addons/escoria/ui-library/dialog/mouse/game.gd"
		"9verbs":
			ui_path = "res://addons/escoria/ui-library/dialog/9-verb/game.gd"
		_:
			ui_path = "" 

	if ui_path != "" and !ProjectSettings.has_setting(ESCProjectSettingsManager.UI_SCRIPT):
		ProjectSettings.set_setting(ESCProjectSettingsManager.UI_SCRIPT, ui_path)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.UI_SCRIPT,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.gd",
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint_tooltip": "Path to the active UI script based on ui_type"
		})
		
		
		

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.INVENTORY_ITEMS_PATH):
		ProjectSettings.set_setting(ESCProjectSettingsManager.INVENTORY_ITEMS_PATH, "res://game/items/inventory")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.INVENTORY_ITEMS_PATH,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.INVENTORY_ITEM_SIZE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.INVENTORY_ITEM_SIZE, Vector2(72, 72))
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.INVENTORY_ITEM_SIZE,
			"type": TYPE_VECTOR2,
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.DEFAULT_TRANSITION):
		ProjectSettings.set_setting(ESCProjectSettingsManager.DEFAULT_TRANSITION, "curtain")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.DEFAULT_TRANSITION,
			"type": TYPE_STRING,
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TRANSITION_PATHS):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TRANSITION_PATHS, ["res://addons/escoria/scenes/transitions/"])
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TRANSITION_PATHS,
			"type": TYPE_PACKED_STRING_ARRAY,
			"hint": PROPERTY_HINT_DIR,
		})

# Prepare the settings in the Escoria sound settings
func set_escoria_sound_settings():
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.MASTER_VOLUME):
		ProjectSettings.set_setting(ESCProjectSettingsManager.MASTER_VOLUME, 0.5)
		ProjectSettings.add_property_info({
			"name":ESCProjectSettingsManager.MASTER_VOLUME,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,1,0.01",
		})

	if !ProjectSettings.has_setting(ESCProjectSettingsManager.MUSIC_VOLUME):
		ProjectSettings.set_setting(ESCProjectSettingsManager.MUSIC_VOLUME, 0.5)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.MUSIC_VOLUME,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,1,0.01",
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SFX_VOLUME):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SFX_VOLUME, 0.5)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SFX_VOLUME,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,1,0.01",
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SPEECH_VOLUME):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SPEECH_VOLUME, 0.5)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SPEECH_VOLUME,
			"type": TYPE_FLOAT,
			"hint": PROPERTY_HINT_RANGE,
			"hint_string": "0,1,0.01",
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SPEECH_ENABLED):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SPEECH_ENABLED, true)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SPEECH_ENABLED,
			"type": TYPE_BOOL,
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SPEECH_FOLDER):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SPEECH_FOLDER, "res://speech")
		ProjectSettings.add_property_info({
			"name":ESCProjectSettingsManager.SPEECH_FOLDER,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SPEECH_EXTENSION):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SPEECH_EXTENSION, "ogg")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SPEECH_EXTENSION,
			"type": TYPE_STRING,
		})

# Prepare the settings in the Escoria platform category and may need special
# setting per build
func set_escoria_platform_settings():
	# General skip cache flag for all platforms
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SKIP_CACHE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SKIP_CACHE, false)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SKIP_CACHE,
			"type": TYPE_BOOL,
			"tooltip": "If true, disables caching of generic scenes (UI, inventory, etc.) to save memory."
		})

	# Specific setting for mobile platforms (usually skip cache to save memory)
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SKIP_CACHE_MOBILE):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SKIP_CACHE_MOBILE, true)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SKIP_CACHE_MOBILE,
			"type": TYPE_BOOL,
			"tooltip": "Overrides skip_cache specifically for mobile platforms."
		})

# List of dialog managers and the one active
func set_escoria_dialog_manager_settings():
	# Si no existe, inicializa la lista con dialog_simple como default
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.DIALOG_MANAGERS):
		ProjectSettings.set_setting(ESCProjectSettingsManager.DIALOG_MANAGERS, [
			"res://addons/escoria/core-scripts/dialog/esc_dialog_simple.gd"])
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.DIALOG_MANAGERS,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_FILE,
			"hint_string": "*.gd",
		})

	# Avatars path for dialog simple
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.AVATAR):
		ProjectSettings.set_setting(ESCProjectSettingsManager.AVATAR, "res://addons/escoria/scenes/avatar.tscn")
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.AVATAR,
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_DIR,
		})

	# Text speed per character
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.SPEED_PER_C):
		ProjectSettings.set_setting(ESCProjectSettingsManager.SPEED_PER_C,  ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_VALUE)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.SPEED_PER_C,
			"type": TYPE_FLOAT,
		})

	# Fast text speed per character (for fast-forward)
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.FAST_TIME_C):
		ProjectSettings.set_setting(ESCProjectSettingsManager.FAST_TIME_C, ESCProjectSettingsManager.TEXT_TIME_PER_CHARACTER_FAST_VALUE)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.FAST_TIME_C,
			"type": TYPE_FLOAT
		})

	# Max time to disappear dialog after finishing text
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.READING_SPEED_IN_WPM):
		ProjectSettings.set_setting(ESCProjectSettingsManager.READING_SPEED_IN_WPM, ESCProjectSettingsManager.READING_SPEED_IN_WPM_VALUE)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.READING_SPEED_IN_WPM,
			"type": TYPE_FLOAT
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS,ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST_VALUE)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS,
			"type": TYPE_FLOAT
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST):
		ProjectSettings.set_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST, ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST_VALUE)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST,
			"type": TYPE_FLOAT,
		})
		
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON):
		ProjectSettings.set_setting(ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON, ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON_END_OF_AUDIO)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON,
			"type": TYPE_STRING,
		})
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.LEFT_CLICK_ACTION):
		ProjectSettings.set_setting(ESCProjectSettingsManager.LEFT_CLICK_ACTION, ESCProjectSettingsManager.LEFT_CLICK_ACTION_SPEED_UP)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.LEFT_CLICK_ACTION,
			"type": TYPE_STRING,
		})
	
	if !ProjectSettings.has_setting(ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY):
		ProjectSettings.set_setting(ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY, true)
		ProjectSettings.add_property_info({
			"name": ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY,
			"type": TYPE_BOOL,
		})

# Uninstall plugin
func _disable_plugin() -> void:
	for key in autoloads.keys():
		if ProjectSettings.has_setting(key):
			remove_autoload_singleton(key)
	if is_instance_valid(popup_info):
		popup_info.queue_free()
	
# Add a dialog manager
func register_dialog_manager(script_path: String):
	var managers = ProjectSettings.get_setting(ESCProjectSettingsManager.DIALOG_MANAGERS)
	if script_path not in managers:
		managers.append(script_path)
		ProjectSettings.set_setting(ESCProjectSettingsManager.DIALOG_MANAGERS, managers)

# Define the active dialog manager
func set_active_dialog_manager(script_path: String) -> bool:
	var managers = ProjectSettings.get_setting(ESCProjectSettingsManager.DIALOG_MANAGERS)
	if script_path in managers:
		ProjectSettings.set_setting(ESCProjectSettingsManager.DIALOG_MANAGERS, script_path)
		return true
	return false

# Return the active dialog manager
func get_active_dialog_manager_class() -> Script:
	var active_path = ProjectSettings.get_setting(ESCProjectSettingsManager.DIALOG_MANAGERS)
	if active_path != "":
		var script = load(active_path)
		if script:
			return script
	return null
