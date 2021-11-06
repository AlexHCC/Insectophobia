extends KinematicBody

#Variables
export var speed = 10
export var acceleration = 0.1
export var deceleration = 0.2
export var jumpPower = 7.5
export var gravity = -0.55
export var cameraPath :NodePath
export var _cameraPivotPath :NodePath
export var _trackPointPath :NodePath
export var _gunPivotPath :NodePath

var _velocity = Vector3.ZERO

onready var _camera = get_node(cameraPath)
onready var _cameraPivot = get_node(_cameraPivotPath)
onready var _trackPoint = get_node(_trackPointPath)
onready var _gunPivot = get_node(_gunPivotPath)


#Functions
func _ready():
	pass


func _physics_process(delta):
	_moveCharacter(delta)


func _moveCharacter(delta):
	#Get camera direction (Needs fixing)
	var forward = Vector3.FORWARD
	if _camera:
		forward = -_camera.global_transform.basis.z.normalized()

	#Get input direction and calculate movement direction
	var input_dir = Vector3()
	if Input.is_action_pressed("player_forward"):
		input_dir += forward
	if Input.is_action_pressed("player_backward"):
		input_dir -= forward
	if Input.is_action_pressed("player_right"):
		input_dir += forward.cross(Vector3.UP)
	if Input.is_action_pressed("player_left"):
		input_dir -= forward.cross(Vector3.UP)
	
	#Normalize, apply speed, and acceleration
	input_dir = input_dir.normalized() * speed
	if input_dir.length() > 0:
		var plane_velocity = _velocity.linear_interpolate(input_dir, acceleration)
		_velocity = Vector3(plane_velocity.x, _velocity.y, plane_velocity.z)
	else:
		var plane_velocity = _velocity.linear_interpolate(Vector3.ZERO, deceleration)
		_velocity = Vector3(plane_velocity.x, _velocity.y, plane_velocity.z)
	
	#Calculate jump
	if not is_on_floor():
		_velocity.y += gravity
	if Input.is_action_pressed("player_jump") and is_on_floor():
		_velocity.y = jumpPower
	
	#Move and slide 
	_velocity = move_and_slide(_velocity, Vector3.UP, true)


func getCameraTrackPoint():
	return _trackPoint


func getCameraPivot():
	return _cameraPivot


func getGunPivot():
	return _gunPivot
