# This is Escoria's singleton script.
# It holds accessors to some utils, such as Escoria's logger.
# The escoria main script
@tool
extends Node
class_name Escoria


# Signal sent when pause menu has to be displayed
signal request_pause_menu
signal resumed

const ESCORIA_CORE_PLUGIN_NAME: String = "escoria"

# Current game state
# * DEFAULT: Common game function
# * DIALOG: Game is playing a dialog
# * WAIT: Game is waiting
enum GAME_STATE {
	DEFAULT,
	DIALOG,
	WAIT,
	LOADING
}


# Audio bus indices.
const BUS_MASTER = "Master"
const BUS_SFX = "SFX"
const BUS_MUSIC = "Music"
const BUS_SPEECH = "Speech"

# Path to camera scene
const CAMERA_SCENE_PATH = "res://addons/escoria/scenes/camera.tscn"


# Group for ESCItem's that can be collided with in a scene. Used for quick
# retrieval of such nodes to easily change their attributes at the same time.
const GROUP_ITEM_CAN_COLLIDE = "item_can_collide"

# Group for ESCItem's that are triggers
const GROUP_ITEM_TRIGGERS = "item_triggers"

const GROUP_INTERACTIVE_ITEM = "esc_interactive_item"
const GROUP_EXIT_ITEM        = "esc_exit_item"
#path
const BASE_PATH = "res://"
# Base folders
const PATH_ASSETS = BASE_PATH + "01_assets"
const PATH_SCENES = BASE_PATH + "02_scenes"
const PATH_THEMES = BASE_PATH +"03_themes"
const PATH_GAME = BASE_PATH + "04_game"

# Subfolders
const PATH_ASSETS_SPRITES = "%s/01_sprites" % PATH_ASSETS
const PATH_ASSETS_FONTS = "%s/02_fonts" % PATH_ASSETS
const PATH_ASSETS_SOUND = "%s/03_sound" % PATH_ASSETS

const PATH_SCENES_AUTOLOAD = "%s/00_autoload" % PATH_SCENES
const PATH_SCENES_CHARACTERS = "%s/01_character" % PATH_SCENES
const PATH_SCENES_OBJECTS = "%s/02_objects" % PATH_SCENES
const PATH_SCENES_OBJECTS_INVENTORY = "%s/02_objects/01_inventory" % PATH_SCENES
const PATH_SCENES_LEVELS = "%s/03_levels" % PATH_SCENES
const PATH_SCENES_SCREENS = "%s/04_screens" % PATH_SCENES
const PATH_SCENES_OTHERS = "%s/05_other" % PATH_SCENES


# Logger instance
var logger 

# ESC Compiler
var esc_compiler = ESCCompiler.new()

# ESC Object Manager
var object_manager = ESCObjectManager.new()

# ESC Room Manager
var room_manager = ESCRoomManager.new()

# Terrain of the current room
var room_terrain

# The inventory manager instance
var inventory_manager: ESCInventoryManager

# The action manager instance
var action_manager: ESCActionManager

# ESC Event manager instance
var event_manager: ESCEventManager

# ESC globals registry instance
var globals_manager: ESCGlobalsManager

# ESC command registry instance
var command_registry: ESCCommandRegistry

# Manager of game settings (resolution, sound, etc)
var settings_manager: ESCSettingsManager

# Resource cache handler
var resource_cache: ESCResourceCache

# Dialog player instantiator. This instance is called directly for dialogs.
var dialog_player: ESCDialogPlayer

# Inventory scene
var inventory

# The main scene
var main

# The escoria inputs manager
var inputs_manager: ESCInputsManager

# Savegames and settings manager
var save_manager: ESCSaveManager

# The game scene loaded
var game_scene: ESCGame

# The main player camera
var player_camera: ESCCamera

# The compiled start script loaded from ProjectSettings
# escoria/main/game_start_script
var start_script: ESCScript

# The "fallback" script to use when an action is tried on an item that hasn't
# been explicitly scripted.
var action_default_script: ESCScript

# Whether we ran a room directly from editor, not a full game
var is_direct_room_run: bool = false

# Whether we're quitting the game
var is_quitting: bool = false

# Whether we're creating a new game
var creating_new_game: bool = false

# The game resolution
@onready var game_size = get_viewport().size

# The current state of the game
@onready var current_state = GAME_STATE.DEFAULT



# Ready function
func _ready():		
	_handle_direct_scene_run()

	settings_manager.load_settings()
	settings_manager.apply_settings()

	room_manager.register_reserved_globals()
	inputs_manager.register_core()

	if ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.GAME_START_SCRIPT
	).is_empty():
		logger.error(
			self,
			"Project setting '%s' is not set!"
					% ESCProjectSettingsManager.GAME_START_SCRIPT
		)
	start_script = esc_compiler.load_esc_file(
		ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.GAME_START_SCRIPT
		)
	)

	if ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT
	).is_empty():
		logger.info(
			self,
			"Project setting '%s' is not set. No action defaults will be used."
					% ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT
		)
	else:
		action_default_script = esc_compiler.load_esc_file(
			ESCProjectSettingsManager.get_setting(
				ESCProjectSettingsManager.ACTION_DEFAULT_SCRIPT
			)
		)

	_perform_plugins_checks()
	player_camera = ESCCamera.new()
	# We check if we run the full game or a room scene directly
	if not get_tree().current_scene is ESCMain:
		# Running a room scene. We need to instantiate the main scene ourselves
		# so that the Escoria scene is created and managers are instanced as well.
		is_direct_room_run = true
		var main_scene = preload("res://addons/escoria/scenes/main_scene.tscn").instantiate()
		add_child(main_scene)
	
	

func _on_game_is_loading():
	logger.info(self, "GAME IS LOADING")

func _on_game_finished_loading():
	logger.info(self, "GAME FINISHED LOADING")



func _init():
	logger = ESCLoggerFile.new()
	inventory_manager = ESCInventoryManager.new()
	action_manager = ESCActionManager.new()
	event_manager = ESCEventManager.new()
	globals_manager = ESCGlobalsManager.new()
	add_child(event_manager)
	object_manager = ESCObjectManager.new()
	command_registry = ESCCommandRegistry.new()
	resource_cache = ESCResourceCache.new()
	add_child(resource_cache)
	save_manager = ESCSaveManager.new()

	save_manager.connect("game_is_loading", self._on_game_is_loading)
	save_manager.connect("game_finished_loading", self._on_game_finished_loading)

	inputs_manager = ESCInputsManager.new()
	settings_manager = ESCSettingsManager.new()

	if ESCProjectSettingsManager.get_setting(ESCProjectSettingsManager.GAME_SCENE
	).is_empty():
		logger.error(
			self,
			"Project setting '%s' is not set!" % ESCProjectSettingsManager.GAME_SCENE
		)
	else:
		game_scene = resource_cache.get_resource(ESCProjectSettingsManager.get_setting(
			ESCProjectSettingsManager.GAME_SCENE)).instantiate()


# Get the Escoria node. That node gives access to the Escoria scene that's
# instanced by the main_scene (if full game is run) or by this autoload if
# room is run directly.
func get_escoria():
	# We check if we run the full game or a room scene directly
	if get_tree().current_scene is ESCMain:
		return get_node("/root/main_scene").escoria_node
	else:
		return get_node("main_scene").escoria_node


# Pauses or unpause the game
#
# #### Parameters
# - p_paused: if true, pauses the game. If false, unpauses the game.
func set_game_paused(p_paused: bool):
	if p_paused:
		emit_signal("request_pause_menu")
	else:
		emit_signal("resumed")

	var scene_tree = get_tree()

	if is_instance_valid(scene_tree):
		scene_tree.paused = p_paused


# Verifies that the game is configured with required plugin(s).
# If a required plugin is missing (or disabled) we stop immediately.
func _perform_plugins_checks():
	if ESCProjectSettingsManager.get_setting(
		ESCProjectSettingsManager.DIALOG_MANAGERS
	).is_empty():
		logger.error(
			self,
			"No dialog manager configured. Please add a dialog manager plugin."
		)


# Manage notifications received from OS
#
# #### Parameters
# - what: the notification constant received (usually defined in MainLoop)
func _notification(what: int):
	match what:
		Node.NOTIFICATION_WM_CLOSE_REQUEST:
			logger.close_logs()
			is_quitting = true
			get_tree().quit()
		Node.NOTIFICATION_WM_GO_BACK_REQUEST:
			logger.close_logs()
			is_quitting = true
			get_tree().quit()


# Called by Escoria's main_scene as very very first event EVER.
# Usually you'll want to show some logos animations before spawning the main
# menu in the escoria/main/game_start_script 's :init event
func init():
	# Don't show the UI until we're ready in order to avoid a sometimes-noticeable
	# blink. The UI will be "shown" later via a visibility update to the first room.
	game_scene.escoria_hide_ui()
	run_event_from_script(start_script, event_manager.EVENT_INIT)
	pass


# Input function to manage specific input keys
#
# #### Parameters
# - event: the input event to manage.
func _input(event: InputEvent):
	if InputMap.has_action(ESCInputsManager.ESC_SHOW_DEBUG_PROMPT) \
			and event.is_action_pressed(ESCInputsManager.ESC_SHOW_DEBUG_PROMPT):
		main.get_node("layers/debug_layer/esc_prompt_popup").popup()

	if event.is_action_pressed("ui_cancel"):
		emit_signal("request_pause_menu")
	pass


# Runs the event "event_name" from the "script" ESC script.
#
# #### Parameters
# - script: ESC script containing the event to run. The script must have been
# loaded.
# - event_name: Name of the event to run
func run_event_from_script(script: ESCScript, event_name: String, from_statement_id: int = 0):
	if script == null:
		logger.error(
			self,
			"Requested action %s on unloaded script %s." % [event_name, script] +
			"Please load the ESC script using esc_compiler.load_esc_file()."
		)
	script.events[event_name].from_statement_id = from_statement_id
	event_manager.queue_event(script.events[event_name])
	var rc = await event_manager.event_finished
	while rc[1] != event_name:
		rc = await event_manager.event_finished

	if rc[0] != ESCExecution.RC_OK:
		logger.error(
			self,
			"Start event of the start script returned unsuccessful: %d." % rc[0]
		)
		return


# Called from escoria autoload to start a new game.
func new_game():
	game_scene.escoria_show_ui()
	globals_manager.clear()
	main.clear_previous_scene()
	creating_new_game = true
	globals_manager.set_global(
			room_manager.GLOBAL_FORCE_LAST_SCENE_NULL,
			true,
			true
		)
	event_manager.interrupt()
	run_event_from_script(start_script, event_manager.EVENT_NEW_GAME)

# Function called to quit the game.
func quit():
	get_tree().notification(Node.NOTIFICATION_WM_CLOSE_REQUEST)
	get_tree().quit()


# Handle anything necessary if the game started a scene directly.
func _handle_direct_scene_run() -> void:
	var current_scene: Node = get_tree().get_current_scene()
	if is_direct_room_run and current_scene is ESCRoom:
		object_manager.set_current_room(current_scene)


# Used by game.gd to determine whether the game scene is ready to take inputs
# from the _input() function. To do so, the current_scene must be set, the game
# scene must be set, and the game scene must've been notified that the room
# is ready.
#
# *Returns*
# true if game scene is ready for inputs
func is_ready_for_inputs() -> bool:
	return main.current_scene and main.current_scene.game \
			and main.current_scene.game.room_ready_for_inputs
