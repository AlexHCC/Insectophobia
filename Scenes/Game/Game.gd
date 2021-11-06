extends Spatial


#Variables
export var controllerMouseSpeed = 5.0

var _hasFocus = true
var _isMouseOnWindow = true


#Functions
func _ready():
	pass


func _physics_process(delta):
	#Basic 8-direction controller movement
	#Need to make it multidirectional 
	#Need to add better camera rotation controls 
	_handle_mouse_to_key_input()


func _handle_mouse_to_key_input():
	#Get mouse offset based on input
	var mouseOffset = Vector2.ZERO
	if Input.is_action_pressed("mouse_up"):
		mouseOffset += Vector2.UP
	if Input.is_action_pressed("mouse_down"):
		mouseOffset += Vector2.DOWN
	if Input.is_action_pressed("mouse_left"):
		mouseOffset += Vector2.LEFT
	if Input.is_action_pressed("mouse_right"):
		mouseOffset += Vector2.RIGHT
	mouseOffset = (mouseOffset.normalized() * controllerMouseSpeed).round()
	
	#Check focus and move mouse inside window
	var newMousePos = get_viewport().get_mouse_position() + mouseOffset
	if _hasFocus and _isMouseOnWindow \
			and (newMousePos.x in range(0, get_viewport().size.x)) \
			and (newMousePos.y in range(0, get_viewport().size.y)):
		Input.warp_mouse_position(get_viewport().get_mouse_position() + mouseOffset)


func _notification(event):
	match event:
		NOTIFICATION_WM_FOCUS_IN:
			_hasFocus = true
		NOTIFICATION_WM_FOCUS_OUT:
			_hasFocus = false
		NOTIFICATION_WM_MOUSE_ENTER:
			_isMouseOnWindow = true
		NOTIFICATION_WM_MOUSE_EXIT:
			_isMouseOnWindow = false
