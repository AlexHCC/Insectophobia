extends InterpolatedCamera


#Variables
export var spin = 0.1
export var minZoom = 0.5
export var maxZoom = 1.5
export var zoomSpeed = 0.1
export var playerControllerPath :NodePath

var _zoom = 1.0

onready var _pivot = get_node(playerControllerPath).getCameraPivot()
onready var _trackPoint = get_node(playerControllerPath).getCameraTrackPoint()


#Functions
func _ready():
	self.target = _trackPoint.get_path()


func _physics_process(delta):
	#Camera zoom
	if Input.is_action_just_released("camera_zoom_in"):
		_zoom -= zoomSpeed
	if Input.is_action_just_released("camera_zoom_out"):
		_zoom += zoomSpeed
	_zoom = clamp(_zoom, minZoom, maxZoom)
	_pivot.scale = Vector3(_zoom, _zoom, _zoom)


func _unhandled_input(event):
	#Camera movement
	if Input.is_action_pressed("camera_move"):
		if event is InputEventMouseMotion:
			_pivot.rotate_y(-lerp(0, spin, event.relative.x/10))
