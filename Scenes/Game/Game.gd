extends Spatial


#Variables
export var controllerMouseSpeed = 10.0

var _hasFocus = true
var _isMouseOnWindow = true


#Functions
func _ready():
	pass


func _physics_process(delta):
	#Basic controller movement
	#Need to add better camera rotation controls 
	_handle_mouse_to_key_input()


func _handle_mouse_to_key_input():
	#Get mouse offset based on input
	var mouseOffset = (Input.get_vector("mouse_left", "mouse_right", "mouse_up", "mouse_down")*controllerMouseSpeed).round()
	
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
