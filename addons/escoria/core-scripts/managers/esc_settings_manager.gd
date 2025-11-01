# Manages settings
class_name ESCSettingsManager


# Template for settings filename
const SETTINGS_TEMPLATE: String = "settings.tres"

# Variable containing the settings folder obtained from Project Settings
var settings_folder: String

# Dictionary containing specific settings that gamedev wants to save in settings
# This variable is access-free. Getting its content is gamedev's duty.
# It is saved with other Escoria settings data when save_settings() is called.
var custom_settings: Dictionary


# Constructor of ESCSaveManager object.
func _init():
	# We leave the calls to ProjectSettings as-is since this constructor can be
	# called from escoria.gd's own.
	settings_folder = ProjectSettings.get_setting(ESCProjectSettingsManager.SETTINGS_PATH)


# Apply the loaded settings
func apply_settings() -> void:
	
	if not Engine.is_editor_hint():
		escoria.logger.info(
			self,
			"******* settings loaded"
		)
		print(ESCProjectSettingsManager.get_setting(
					ESCProjectSettingsManager.MASTER_VOLUME
				))
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(escoria.BUS_MASTER),
			linear_to_db(
				ESCProjectSettingsManager.get_setting(
					ESCProjectSettingsManager.MASTER_VOLUME
				)
			)
		)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(escoria.BUS_SFX),
			linear_to_db(
				ESCProjectSettingsManager.get_setting(
					ESCProjectSettingsManager.SFX_VOLUME
				)
			)
		)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(escoria.BUS_MUSIC),
			linear_to_db(
				ESCProjectSettingsManager.get_setting(
					ESCProjectSettingsManager.MUSIC_VOLUME
				)
			)
		)
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index(escoria.BUS_SPEECH),
			linear_to_db(
				ESCProjectSettingsManager.get_setting(
					ESCProjectSettingsManager.SPEECH_VOLUME
				)
			)
		)
		var want_fullscreen = ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.FULLSCREEN)

		DisplayServer.window_set_mode( want_fullscreen)
		
		TranslationServer.set_locale(
			ESCProjectSettingsManager.get_setting(
				ESCProjectSettingsManager.TEXT_LANG
			)
		)

		escoria.game_scene.apply_custom_settings(custom_settings)


func save_settings_resource_to_project_settings(settings: ESCSaveSettings):
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.TEXT_LANG,
		settings.text_lang
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.VOICE_LANG,
		settings.voice_lang
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.SPEECH_ENABLED,
		settings.speech_enabled
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.MASTER_VOLUME,
		settings.master_volume
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.MUSIC_VOLUME,
		settings.music_volume
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.SFX_VOLUME,
		settings.sfx_volume
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.SPEECH_VOLUME,
		settings.speech_volume
	)
	ESCProjectSettingsManager.set_setting(
		ESCProjectSettingsManager.FULLSCREEN,
		settings.fullscreen
	)
	custom_settings = settings.custom_settings


# Load the game settings from the settings file
func load_settings():
	var save_settings_path: String = \
			settings_folder +(SETTINGS_TEMPLATE)
	if not FileAccess.file_exists(save_settings_path):
		escoria.logger.warn(
			self,
			"Settings file %s doesn't exist" % save_settings_path
					+ "Setting default settings."
		)
		get_settings()
		save_settings()

	var settings: ESCSaveSettings = load(save_settings_path)
	save_settings_resource_to_project_settings(settings)

# Load the game settings from the settings file
# **Returns** An ESCSaveSettings resource
func get_settings() -> ESCSaveSettings:
	var settings: ESCSaveSettings = ESCSaveSettings.new()
	var plugin_config = ConfigFile.new()
	plugin_config.load("res://addons/escoria/plugin.cfg")
	settings.escoria_version = plugin_config.get_value("plugin", "version")

	settings.text_lang = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.TEXT_LANG
	)
	settings.voice_lang = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.VOICE_LANG
	)
	settings.speech_enabled = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.SPEECH_ENABLED
	)
	settings.master_volume = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.MASTER_VOLUME
	)
	settings.music_volume = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.MUSIC_VOLUME
	)
	settings.sfx_volume = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.SFX_VOLUME
	)
	settings.speech_volume = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.SPEECH_VOLUME
	)
	settings.fullscreen = ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.FULLSCREEN
	)
	
	settings.custom_settings = {
		ESCProjectSettingsManager.FORCE_QUIT: ProjectSettings.get_setting(ESCProjectSettingsManager.FORCE_QUIT),
		ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE: ProjectSettings.get_setting(ESCProjectSettingsManager.DEFAULT_DIALOG_TYPE),
		ESCProjectSettingsManager.DEFAULT_TRANSITION:ProjectSettings.get_setting(ESCProjectSettingsManager.DEFAULT_TRANSITION),
		ESCProjectSettingsManager.UI_SCRIPT:ProjectSettings.get_setting(ESCProjectSettingsManager.UI_SCRIPT),
		ESCProjectSettingsManager.GAME_SCENE:ProjectSettings.get_setting(ESCProjectSettingsManager.GAME_SCENE),
		ESCProjectSettingsManager.INVENTORY_ITEMS_PATH:ProjectSettings.get_setting(ESCProjectSettingsManager.INVENTORY_ITEMS_PATH),
		ESCProjectSettingsManager.INVENTORY_ITEM_SIZE:ProjectSettings.get_setting(ESCProjectSettingsManager.INVENTORY_ITEM_SIZE),
		ESCProjectSettingsManager.TRANSITION_PATHS:ProjectSettings.get_setting(ESCProjectSettingsManager.TRANSITION_PATHS),
		ESCProjectSettingsManager.COMMAND_DIRECTORIES:ProjectSettings.get_setting(ESCProjectSettingsManager.COMMAND_DIRECTORIES),
		ESCProjectSettingsManager.GAME_VERSION:ProjectSettings.get_setting(ESCProjectSettingsManager.GAME_VERSION),
		ESCProjectSettingsManager.GAME_START_SCRIPT:ProjectSettings.get_setting(ESCProjectSettingsManager.GAME_START_SCRIPT),
		ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT:ProjectSettings.get_setting(ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT),
		ESCProjectSettingsManager.TEXT_LANG:ProjectSettings.get_setting(ESCProjectSettingsManager.TEXT_LANG),
		ESCProjectSettingsManager.VOICE_LANG:ProjectSettings.get_setting(ESCProjectSettingsManager.VOICE_LANG),
		ESCProjectSettingsManager.FAST_TIME_C:ProjectSettings.get_setting(ESCProjectSettingsManager.FAST_TIME_C),
		ESCProjectSettingsManager.SPEED_PER_C:ProjectSettings.get_setting(ESCProjectSettingsManager.SPEED_PER_C),
		ESCProjectSettingsManager.AVATAR:ProjectSettings.get_setting(ESCProjectSettingsManager.AVATAR ),
		ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY:ProjectSettings.get_setting(ESCProjectSettingsManager.CLEAR_TEXT_BY_CLICK_ONLY),
		ESCProjectSettingsManager.LEFT_CLICK_ACTION:ProjectSettings.get_setting(ESCProjectSettingsManager.LEFT_CLICK_ACTION),
		ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON:ProjectSettings.get_setting(ESCProjectSettingsManager.STOP_TALKING_ANIMATION_ON),
		ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS:ProjectSettings.get_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS),
		ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST:ProjectSettings.get_setting(ESCProjectSettingsManager.TEXT_TIME_PER_LETTER_MS_FAST),
		ESCProjectSettingsManager.READING_SPEED_IN_WPM:ProjectSettings.get_setting(ESCProjectSettingsManager.READING_SPEED_IN_WPM),
		ESCProjectSettingsManager.CRASH_MESSAGE:ProjectSettings.get_setting(ESCProjectSettingsManager.CRASH_MESSAGE),
		ESCProjectSettingsManager.DEVELOPMENT_LANG:ProjectSettings.get_setting(ESCProjectSettingsManager.DEVELOPMENT_LANG),
		ESCProjectSettingsManager.ENABLE_HOVER_STACK_VIEWER:ProjectSettings.get_setting(ESCProjectSettingsManager.ENABLE_HOVER_STACK_VIEWER),
		ESCProjectSettingsManager.ENABLE_ROOM_SELECTOR:ProjectSettings.get_setting(ESCProjectSettingsManager.ENABLE_ROOM_SELECTOR),
		ESCProjectSettingsManager.LOG_FILE_PATH:ProjectSettings.get_setting(ESCProjectSettingsManager.LOG_FILE_PATH),
		ESCProjectSettingsManager.LOG_LEVEL:ProjectSettings.get_setting(ESCProjectSettingsManager.LOG_LEVEL),
		ESCProjectSettingsManager.TERMINATE_ON_ERRORS:ProjectSettings.get_setting(ESCProjectSettingsManager.TERMINATE_ON_ERRORS),
		ESCProjectSettingsManager.ROOM_SELECTOR_ROOM_DIR:ProjectSettings.get_setting(ESCProjectSettingsManager.ROOM_SELECTOR_ROOM_DIR),
		ESCProjectSettingsManager.TERMINATE_ON_WARNINGS:ProjectSettings.get_setting(ESCProjectSettingsManager.TERMINATE_ON_WARNINGS),	
		ESCProjectSettingsManager.SKIP_CACHE:ProjectSettings.get_setting(ESCProjectSettingsManager.SKIP_CACHE),
		ESCProjectSettingsManager.SKIP_CACHE_MOBILE:ProjectSettings.get_setting(ESCProjectSettingsManager.SKIP_CACHE_MOBILE)}
	
	settings.custom_settings = custom_settings

	return settings


func load_settings_from_dict(settings_dict: Dictionary):
	var settings: ESCSaveSettings = ESCSaveSettings.new()
	settings.escoria_version = settings_dict["escoria_version"]
	settings.text_lang = settings_dict["text_lang"]
	settings.voice_lang = settings_dict["voice_lang"]
	settings.speech_enabled = settings_dict["speech_enabled"]
	settings.master_volume = settings_dict["master_volume"]
	settings.music_volume = settings_dict["music_volume"]
	settings.sfx_volume = settings_dict["sfx_volume"]
	settings.speech_volume = settings_dict["speech_volume"]
	settings.fullscreen = settings_dict["fullscreen"]
	settings.custom_settings = settings_dict["custom_settings"]
	save_settings_resource_to_project_settings(settings)


# Load the game settings from the settings file
# **Returns** An Dictionary containing the settings
func get_settings_dict() -> Dictionary:
	var settings: ESCSaveSettings = get_settings()
	var settings_dict: Dictionary = {}
	settings_dict["escoria_version"] = settings.escoria_version
	settings_dict["text_lang"] = settings.text_lang
	settings_dict["voice_lang"] = settings.voice_lang
	settings_dict["speech_enabled"] = settings.speech_enabled
	settings_dict["master_volume"] = settings.master_volume
	settings_dict["music_volume"] = settings.music_volume
	settings_dict["sfx_volume"] = settings.sfx_volume
	settings_dict["speech_volume"] = settings.speech_volume
	settings_dict["fullscreen"] = settings.fullscreen
	settings_dict["custom_settings"] =  settings.custom_settings

	return settings_dict


# Save the game settings in the settings file.
func save_settings():
	var settings = get_settings()

	var directory = DirAccess.open(settings_folder)
	if not directory:
		directory.make_dir_recursive(settings_folder)

	var save_path = settings_folder + (SETTINGS_TEMPLATE)
	var error: int = ResourceSaver.save(settings, save_path)
	if error != OK:
		escoria.logger.error(
			self,
			"There was an issue writing settings %s" % save_path
		)
