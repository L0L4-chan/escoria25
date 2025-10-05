# A walkable Terrains
@tool
@icon("res://addons/escoria/assets/image/esc_terrain.svg")
extends Node2D
class_name ESCTerrain 

# Visualize scales or the lightmap for debugging purposes
enum DebugMode {
	NONE,
	SCALES,
	LIGHTMAP
}

# Scaling texture
@export var scales : Texture : set = _set_scales

# Minimum scaling
@export var scale_min = 0.3

# Maximum scaling
@export var scale_max = 1.0

# Lightmap texture
@export var lightmap : Texture : set = _set_lightmap

# The scaling factor for the scale and light maps
@export var bitmaps_scale = Vector2(1,1) : set = _set_bm_scale

# Multiplier applied to the player speed on this terrain
@export var player_speed_multiplier = 1.0

# Multiplier how much faster the player will walk when fast mode is on
# (double clicked)
@export var player_doubleclick_speed_multiplier = 1.5

# Additional modulator to the lightmap texture
@export var lightmap_modulate = Color(1, 1, 1, 1)

# Currently selected debug visualize mode
@export_enum("None", "Scales", "Lightmap") var debug_mode : int = DebugMode.NONE : set = _set_debug_mode

# The currently activ navigation polygon
var current_active_navigation_instance: NavigationRegion2D = null

# Currently visualized texture for debug mode
var _texture = null

# The image from the lightmap texture
var _lightmap_data

# Prohibits multiple calls to update_texture
var _texture_in_update = false

# Logger instance
@onready var logger = ESCLoggerFile.new()

# Set a reference to the active navigation polygon, register to Escoria
# and update the texture
func _ready():
	connect("child_entered_tree", self._check_multiple_enabled_navpolys)
	child_exiting_tree.connect( self._check_multiple_enabled_navpolys.bind(true))

	_check_multiple_enabled_navpolys()
	if !Engine.is_editor_hint():
		escoria.room_terrain = self
	_update_texture()


# Returns all NavigationPolygonInstances defined as children of ESCTerrain in an Array.
#
# **Returns**
# A list of NavigationPolygons nodes
func get_children_navpolys() -> Array:
	var navpolys: Array = []
	for n in get_children():
		if n is NavigationRegion2D:
			navpolys.push_back(n)
	return navpolys


# Checks whether multiple navigation polygons are enabled.
# Shows a warning in the terminal if this happens.
# #### Parameters
#
# - node: if this method is triggered by child_entered_tree or
# child_exited_tree signals, parameter is the added node.
func _check_multiple_enabled_navpolys(node: Node = null, is_exiting: bool = false) -> void:
	var navigation_enabled_found = false
	if node != null and not is_exiting and node is NavigationRegion2D and node.is_enabled():
		navigation_enabled_found = true

	for n in get_children():
		if is_exiting and n == node:
			continue
		if n is NavigationRegion2D and n.is_enabled():
			if navigation_enabled_found:
				if Engine.is_editor_hint():
					logger.warn(
						self,
						"Multiple NavigationRegion2Ds enabled " + \
						"at the same time."
					)
				else:
					logger.error(
						self,
						"Multiple NavigationRegion2Ds enabled " + \
						"at the same time."
					)
				return
			else:
				navigation_enabled_found = true
				current_active_navigation_instance = n


# Return the Color of the lightmap pixel for the specified position
#
# #### Parameters
#¡¡¡¡ lightmap ought to be same size as the background!!!!
# - pos: Position to calculate lightmap for
# **Returns** The color of the given point
func get_light(pos: Vector2) -> Color:
	if not lightmap or lightmap.get_image().is_empty():
		return Color(1, 1, 1, 1)

	var img: Image = lightmap.get_image()
	var tex_w: int = img.get_width()
	var tex_h: int = img.get_height()
	var walkable_size = Vector2(tex_w, tex_h)
	
	# --- 2. Calculate position ---
	var local_pos = (pos - global_position) / bitmaps_scale
	var tex_x: int = int(clamp(local_pos.x / walkable_size.x * tex_w, 0, tex_w - 1))
	var tex_y: int = int(clamp(local_pos.y / walkable_size.y * tex_h, 0, tex_h - 1))

	# --- 3. read pixel ---
	var pixel_color: Color = img.get_pixel(tex_x, tex_y)

	# --- 4. if is transparent use (1,1,1,1) ---
	if pixel_color == Color(0, 0, 0, 0):
		return Color(1, 1, 1, 1) 

	# --- 5. Apply ---
	var final_color: Color = pixel_color * lightmap_modulate
	return final_color


# Calculate the scale inside the scale range for a given scale factor
#
# #### Parameters
#
# - factor: The factor for the scaling according to the scale map
# **Returns** The scaling
func get_scale_range(factor: float) -> Vector2:
	factor = scale_min + (scale_max - scale_min) * factor
	return Vector2(factor, factor)


# Get the terrain scale factor for a given position
#
# #### Parameters
#
# - pos: The position to calculate for
# **Returns** The scale factor for the given position
func get_terrain(pos: Vector2) -> float:
	if not scales or scales.get_image().is_empty():
		return 1.0
	var scale_image = scales.get_image()
	
	#var local_pos = (pos - global_position) / bitmaps_scale

	var c = _get_color(scale_image, pos)  # Color del pixel
	var factor = (c.r + c.g + c.b) / 3.0
	factor = scale_min + (scale_max - scale_min) * factor	
	return factor



# Small helper to get the color of an image at a position
func _get_color(image: Image, pos: Vector2) -> Color:
	var x = int(pos.x)
	var y = int(pos.y)
	return image.get_pixel(int(pos.x), int(pos.y))


# Set the bitmap scaling
#
# #### Parameters
#
# - p_scale: Scale to set
func _set_bm_scale(p_scale: Vector2):
	bitmaps_scale = p_scale
	_update_texture()


# Safely set the lightmap texture for Godot 4.x
#
# Parameters:
# - p_lightmap: Lightmap texture to set (can be null)
func _set_lightmap(p_lightmap: Texture) -> void:
	var need_init = (lightmap != p_lightmap) or (lightmap and not _lightmap_data)
	lightmap = p_lightmap
	if need_init:
	# Unlock previous image if any
		if _lightmap_data:
			_lightmap_data = null
		
		# Only get image if lightmap is valid
		if lightmap:
		# Works for ImageTexture2D and CompressedTexture2D
			_lightmap_data = lightmap.get_image()
		else:
			_lightmap_data = null  # safe fallback
	# Update the texture (existing function)
	_update_texture()


# Set the scales texture
#
# #### Parameters
#
# - p_scales: Scale texture to set
func _set_scales(p_scales: Texture):
	scales = p_scales
	_update_texture()


# Set the debug mode
#
# #### Parameters
#
# - p_mode: Debug mode to set
func _set_debug_mode(p_mode: int):
	debug_mode = p_mode
	_update_texture()


# Update the debug texture, if it is dirty
func _update_texture():
	if _texture_in_update:
		return
	_texture_in_update = true
	call_deferred("_do_update_texture")


# Update the texture and optionally set the debug texture
func _do_update_texture():
	_texture_in_update = false
	if !is_inside_tree() or !Engine.is_editor_hint():
		return

	if debug_mode == DebugMode.NONE:
		queue_redraw()
		return

	_texture = ImageTexture.new()
	if debug_mode == DebugMode.SCALES:
		if scales != null:
			_texture = scales
	elif debug_mode == DebugMode.LIGHTMAP:
		if lightmap != null:
			_texture = lightmap

	queue_redraw()


# Draw debugging visualizations
func _draw():
	if _texture == null or \
			not Engine.is_editor_hint() or \
			debug_mode == DebugMode.NONE:
		if current_active_navigation_instance:
			current_active_navigation_instance.visible = true
		return

	var scale_vect = bitmaps_scale

	if current_active_navigation_instance:
		current_active_navigation_instance.visible = false

	var src = Rect2(0, 0, _texture.get_width(), _texture.get_height())
	var dst = Rect2(
		0,
		0,
		_texture.get_width() * scale_vect.x,
		_texture.get_height() * scale_vect.y
	)

	draw_texture_rect_region(_texture, dst, src)
	
##
# Return a path like Navigation2D at Godot 3.x
##
func get_simple_path(start: Vector2, end: Vector2, optimize: bool = true) -> PackedVector2Array:
	if not current_active_navigation_instance:
		return PackedVector2Array()
	var nav_map: RID = current_active_navigation_instance.get_navigation_map()

	var path: PackedVector2Array = NavigationServer2D.map_get_path(nav_map, start, end, optimize)

	if path.is_empty():
		path.append(start)
		path.append(end)
	else:
		if path[0] != start:
			path.insert(0, start)
		if path[-1] != end:
			path.append(end)
	return path
