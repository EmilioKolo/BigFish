extends CanvasLayer


# Direccion hasta el menu
var menu_res_path = "res://UI/menu.tscn"; 

# Agarro nodos
@onready var prof_label = get_node("HBoxContainer/VBoxContainer2/MarginContainer/profundidad"); 
@onready var size_label = get_node("HBoxContainer/VBoxContainer2/MarginContainer2/tamano"); 
@onready var bg_node = get_node("Background"); 

# Defino senales
signal exit_game
signal change_prof(p)


# Funcion para ver input todos los frames
func _input(_event):
	# Al apretar escape se abre el menu
	if Input.is_action_just_released("ui_cancel"):
		open_menu(); 


# Funcion para abrir el menu
func open_menu():
	### TEMPORAL
	# Emito la senal de cerrar el juego
	exit_game.emit(); 

# Funcion para actualizar la profundidad
func update_prof(p):
	### TEMPORAL
	# Lo pongo en label
	prof_label.text = "PROFUNDIDAD: " + str(p); 
	change_prof.emit(p); 

# Funcion para actualizar el tamano de personaje
func update_size():
	### TEMPORAL
	# Lo pongo en label
	size_label.text = "TAMAÑO: " + str(Global.player_size); 
	var size_tween = get_tree().create_tween(); 
	var newsize = Vector2(Global.camera_scale, Global.camera_scale); 
	size_tween.tween_property(bg_node, "scale", newsize, Global.zoom_tweentime); 


# Cuando aprieto el boton X
func _on_exit_pressed():
	# Al apretar el boton X se abre el menu
	open_menu(); 

