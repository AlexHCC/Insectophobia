extends Position3D

#Variables
export var cameraPath :NodePath
export var playerControllerPath :NodePath

var _startCamearAngle

onready var _camera = get_node(cameraPath)
onready var _gunPivot = get_node(playerControllerPath).getGunPivot()


#Functions
func _ready():
	_startCamearAngle = _getCameraAngle()


func _physics_process(delta):
	#Translation
	self.translation = get_parent().to_local(_gunPivot.get_parent().to_global(_gunPivot.translation))
	
	#Rotation
	#Changes camera angle regardless of starting rotation, so that it looks away from the camera
	#Adds the negative (mouse position + PI/2) so that it transforms from 2D coordinates to 3D
	self.rotation.y = _getCameraAngle() - _startCamearAngle - _getMouseAngle() - PI/2


func _getCameraAngle():
	var cameraForward = -_camera.global_transform.basis.z.normalized()
	var cameraVector = -cameraForward.cross(Vector3.UP)
	var cameraAngle = Vector2(-cameraVector.x, cameraVector.z).angle()
	return cameraAngle


func _getMouseAngle():
	var pivotPos = _camera.unproject_position(get_parent().to_global(translation))
	var mousePos = get_viewport().get_mouse_position()
	var mouseAngle = (mousePos - pivotPos).angle()
	return mouseAngle
