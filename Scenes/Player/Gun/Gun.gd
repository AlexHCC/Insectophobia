extends Position3D

#Variables
export var rayLength = 10000
export var shootingDepth = 0.1
export var cameraPath :NodePath
export var playerControllerPath :NodePath

var _startCamearAngle

onready var _camera = get_node(cameraPath)
onready var _gunPivot = get_node(playerControllerPath).getGunPivot()


#Functions
func _ready():
	_startCamearAngle = _getCameraAngle()


func _physics_process(delta):
	_translateGun()
	_shootGun_shootGun()


func _shootGun_shootGun():
	var spaceState = get_world().direct_space_state
	
	if Input.is_action_just_pressed("gun_shoot"):
		print("Click")
		#Get shooting point
		var from = _camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + _camera.project_ray_normal(get_viewport().get_mouse_position()) * rayLength
		var cameraRay = spaceState.intersect_ray(from, to)
		
		#Shoot ray
		if cameraRay:
			var extendedCameraRay = (cameraRay.position - _camera.get_parent().to_global(_camera.translation)).normalized() * shootingDepth
			$RayCast.cast_to = $RayCast.to_local(extendedCameraRay + cameraRay.position)
			
			#Rotate gun
			$GunMesh.look_at(cameraRay.position, Vector3.UP)
			$GunMesh.rotate_object_local(Vector3(0, 1, 0), PI)
			$GunMesh.rotation.y = 0
			$GunMesh.rotation.x = clamp($GunMesh.rotation.x, deg2rad(-70), deg2rad(70))
			
			#Check for collisions with enemies
			if $RayCast.get_collider() and $RayCast.get_collider().is_in_group("Enemy"):
				$RayCast.get_collider().hit(500)
			#Send damage and event
			#Play animation and sounds


func _translateGun():
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
