extends KinematicBody


#Variables
export var health = 1000
export var speed = 10
export var attackSpeed = 8

var path = []
var pathNode = 0

onready var nav = get_parent().get_parent().get_node("Navigation")
onready var player = get_parent().get_parent().get_node("Player/PlayerController")

enum State {STATE_IDLE, STATE_PATROL, STATE_CHASE, STATE_ATTACK, STATE_REGROUP, STATE_DEAD}
var currentState = State.STATE_IDLE


#Functions
func _ready():
	path = nav.get_simple_path(get_parent().to_global(self.translation), player.get_parent().to_global(player.translation))


func _physics_process(delta):
	match currentState:
		State.STATE_IDLE:
			_state_idle()
		State.STATE_PATROL:
			_state_patrol()
		State.STATE_CHASE:
			_state_chase()
		State.STATE_ATTACK:
			_state_attack()
		State.STATE_ATTACK:
			_state_regroup()
		State.STATE_DEAD:
			_state_dead()


func _state_idle():
	if get_parent().to_global(self.translation).distance_to(player.get_parent().to_global(player.translation)) < 10:
		currentState = State.STATE_CHASE


func _state_patrol():
	#var radius = 10
	#move_and_slide(Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius)), Vector3.UP)
	pass


func _state_chase():
	if pathNode < path.size():
		var direction = (path[pathNode] - global_transform.origin)
		if direction.length() < 1:
			pathNode += 1
		else:
			move_and_slide(direction.normalized() * speed, Vector3.UP)
			look_at(get_parent().to_local(path[pathNode]), Vector3.UP)
	else:
		currentState = State.STATE_ATTACK


func _on_Timer_timeout():
	path = nav.get_simple_path(get_parent().to_global(self.translation), player.get_parent().to_global(player.translation))
	pathNode = 0


func _state_attack():
	var attackPath = nav.get_simple_path(get_parent().to_global(self.translation), player.get_parent().to_global(player.translation))
	if attackPath.size() < 5:
		move_and_slide((attackPath[attackPath.size()-1] - global_transform.origin).normalized() * attackSpeed, Vector3.UP)
		look_at(get_parent().to_local(attackPath[attackPath.size()-1]), Vector3.UP)
	else:
		currentState = State.STATE_CHASE
	
	#Get colliding bodies
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		print(collision.collider.is_in_group("Enemy"))


func _state_regroup():
	pass


func _state_dead():
	pass



func _moveToPos(position):
	var path = nav.get_simple_path(get_parent().to_global(self.translation), position)




func hit(damage):
	#Health
	health -= damage
	if health <= 0:
		$BugModel.visible = false
		$DeadBugModel.visible = true
		currentState = State.STATE_DEAD
	else:
		print("Got hit: ", damage)
	


"""
	func _physics_process(delta):
		if pathNode < path.size():
			var direction = (path[pathNode] - global_transform.origin)
			if direction.length() < 1:
				pathNode += 1
			else:
				move_and_slide(direction.normalized() * speed, Vector3.UP)


	func moveTo(targetPos):
		path = nav.get_simple_path(global_transform.origin, targetPos)
		pathNode = 0



	func _on_Timer_timeout():
		moveTo(player.global_transform.origin)
"""
