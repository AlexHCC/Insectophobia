extends Control


#Variables


#Functions
func _ready():
	pass


func _physics_process(delta):
	pass


#Event callbacks


func _on_Play_button_up():
	get_tree().change_scene("res://PrototypeLevel/PrototypeLevel.tscn")


func _on_Settings_button_up():
	pass # Replace with function body.


func _on_Credits_button_up():
	pass # Replace with function body.


func _on_Quit_button_up():
	$ColorRect2.visible = true
	$ColorRect2/QuitDialog.popup()


func _on_QuitDialog_popup_hide():
	$ColorRect2.visible = false
