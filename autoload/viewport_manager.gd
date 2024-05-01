extends Node

const BASE_RESOLUTION:Vector2 = Vector2(192, 144)

var integer_scaling:bool = true
var sub_pixel_animations:bool = true
var _viewport_shaking:Vector2 = Vector2(0,0)

func _ready():
	get_tree().connect("screen_resized", self, "recalculate_viewport_rect")

func _process(delta):
	recalculate_viewport_rect()

func recalculate_viewport_rect():
	if integer_scaling:
		recalculate_viewport_rect_with_integer_scaling()
		return
	
	recalculate_viewport_rect_without_integer_scaling()
	


func recalculate_viewport_rect_with_integer_scaling():
	var window_size = OS.get_window_size()
	var viewport = get_viewport()
	
	# see how big the window is compared to the viewport size
	# floor it so we only get round numbers (0, 1, 2, 3 ...)
	var scale_x = floor(window_size.x / BASE_RESOLUTION.x)
	var scale_y = floor(window_size.y / BASE_RESOLUTION.y)
	
	# use the smaller scale with 1x minimum scale
	var scale = max(1, min(scale_x, scale_y))
	
	viewport.size_override_stretch = true
	viewport.set_size_override(true, BASE_RESOLUTION)
	
	# whether sub-pixels should exist or not
	if sub_pixel_animations:
		viewport.size = BASE_RESOLUTION * scale
	else:
		viewport.size = BASE_RESOLUTION
	
	# find the coordinate we will use to center the viewport inside the window
	var diff = window_size - (BASE_RESOLUTION * scale)
	var diffhalf = (diff * 0.5).floor()
	
	# attach the viewport to the rect we calculated
	viewport.set_attach_to_screen_rect(Rect2(diffhalf + _viewport_shaking, BASE_RESOLUTION*scale))
	
	#aspect bars
	VisualServer.black_bars_set_margins(diffhalf.x + _viewport_shaking.x, diffhalf.y + _viewport_shaking.y, diffhalf.x + _viewport_shaking.x, diffhalf.y + _viewport_shaking.y)


func recalculate_viewport_rect_without_integer_scaling():
	var window_size = OS.get_window_size()
	var viewport = get_viewport()
	
	var scale_x = (window_size.x / BASE_RESOLUTION.x)
	var scale_y = (window_size.y / BASE_RESOLUTION.y)
	
	var scale = min(scale_x, scale_y)
	
	viewport.size_override_stretch = true
	viewport.set_size_override(true, BASE_RESOLUTION)
	
	
	viewport.size = BASE_RESOLUTION * scale
	var viewport_position = Vector2( (window_size.x - viewport.size.x) * 0.5 , (window_size.y - viewport.size.y) * 0.5 ).round()
	var viewport_size = Vector2( viewport.size.x , viewport.size.y )
	
	# whether sub-pixels should exist or not
	if !sub_pixel_animations:
		viewport.size = BASE_RESOLUTION
		viewport_position = Vector2( (window_size.x - viewport.size.x * scale) * 0.5 , (window_size.y - viewport.size.y*scale) * 0.5 ).round()
		viewport_size = Vector2( viewport.size.x * scale , viewport.size.y*scale)
	
	
	viewport.set_attach_to_screen_rect(Rect2(viewport_position + _viewport_shaking, viewport_size))
	
	# reason why same params: one black bar size is the same as the oposing black bar
	VisualServer.black_bars_set_margins(viewport_position.x, viewport_position.y, viewport_position.x, viewport_position.y)
