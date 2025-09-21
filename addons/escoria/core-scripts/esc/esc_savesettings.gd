# Resource holding game settings. Note that we call directly to ProjectSettings
# for instance variable initialization since this class is instantiated from
# escoria.gd.
extends Resource
class_name ESCSaveSettings

# Version of ESCORIA Framework
@export var escoria_version: String

# Language of displayed text
@export var text_lang: String = ProjectSettings.get_setting(
	ESCProjectSettingsManager.TEXT_LANG
)

# Language of voice speech
@export var voice_lang: String = ProjectSettings.get_setting(
	ESCProjectSettingsManager.VOICE_LANG
)

# Whether speech is enabled
@export var speech_enabled: bool = ProjectSettings.get_setting(
	ESCProjectSettingsManager.SPEECH_ENABLED)

# Master volume (mix of music, voice and sfx)
@export var master_volume: float = ProjectSettings.get_setting(
	ESCProjectSettingsManager.MASTER_VOLUME)

# Volume of music only
@export var music_volume: float = ProjectSettings.get_setting(
	ESCProjectSettingsManager.MUSIC_VOLUME)

# Volume of SFX only
@export var sfx_volume: float = ProjectSettings.get_setting(
	ESCProjectSettingsManager.SFX_VOLUME
)

# Speech volume only
@export var speech_volume: float = ProjectSettings.get_setting(
	ESCProjectSettingsManager.SPEECH_VOLUME)

# True if game has to be fullscreen
@export var fullscreen: bool = ProjectSettings.get_setting(
	ESCProjectSettingsManager.FULLSCREEN)

# Dictionary containing all user-defined settings.
@export var custom_settings: Dictionary
