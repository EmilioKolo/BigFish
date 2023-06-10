extends Node2D


# Direccion hasta el menu
var menu_res_path = "res://UI/menu.tscn"; 

# Registro profundidad
var prof = 1; 

# Hago preload de las escenas que se spawnean
var bubble_scene = preload("res://characters/bubble_sprite.tscn"); 
var small_fish_scene = preload("res://characters/fish_sprite.tscn"); 
var mid_fish_scene = preload("res://characters/fish_char.tscn"); 

# Lista de direcciones posibles
var directions = [[0,1], [0,-1], [1,0], [-1,0]]; 
#var directions = [[1,0], [-1,0]]; 
#var directions = [[0,1], [0,-1]]; 


# Agarro nodos
@onready var ui_node = get_node("ui"); 
@onready var player_node = get_node("player"); 
@onready var char_container_node = get_node("chars"); 
@onready var camera_node = get_node("Camera2D"); 
@onready var limits_node = get_node("Limites"); 
@onready var bgmusic_node = get_node("bgmusic"); 
@onready var music_node = get_node("music"); 
@onready var winsound_node = get_node("win_sound"); 



func _ready():
	# Randomize por las dudas
	randomize(); 
	# Inicializo global player_size
	Global.player_size = Global.base_player_size; 
	# Uso la funcion unida a la senal para actualizar el tamano de player
	_on_player_size_change(); 
	# Arranco los soundtracks
	bgmusic_node.play(); 
	music_node.play(); 
	# Inicializo musica de acuerdo a Global.music_on
	AudioServer.set_bus_mute(0, not Global.music_on); 


# Funcion para ver input todos los frames
func _input(_event):
	# Al apretar escape se cierra el juego
	if Input.is_action_just_pressed("action"):
		player_node.set_self_size(player_node.char_size-1); 
	if Input.is_action_just_pressed("sound"):
		switch_music(); 


func spawn_fish(used_scene):
	randomize(); 
	# Defino la direccion de la que salen los peces
	var fish_dir = directions[randi()%directions.size()]; 
	# Defino el porcentaje del lado en donde aparece el pez
	var frac_pos_ini = randf_range(0.05, 0.90); 
	# Inicializo fish_instance
	var fish_instance = used_scene.instantiate(); 
	# Si es izquierda o derecha, acomodo scale acorde
	if fish_dir[0]:
		fish_instance.scale_dir = -fish_dir[0]; 
	# Si es top o down, uso random
	else:
		fish_instance.scale_dir = ((randi()%2)*2)-1; 
	# Asigno direction
	fish_instance.direction = fish_dir; 
	# Defino posicion inicial
	if fish_dir==[1,0]:
		fish_instance.position.x = Global.limit_x[0]; 
		fish_instance.position.y = Global.limit_y[1]*frac_pos_ini; 
	elif fish_dir==[-1,0]:
		fish_instance.position.x = Global.limit_x[1]; 
		fish_instance.position.y = Global.limit_y[1]*frac_pos_ini; 
	elif fish_dir==[0,1]:
		fish_instance.position.y = Global.limit_y[0]; 
		fish_instance.position.x = Global.limit_x[1]*frac_pos_ini; 
	elif fish_dir==[0,-1]:
		fish_instance.position.y = Global.limit_y[1]; 
		fish_instance.position.x = Global.limit_x[1]*frac_pos_ini; 
	else:
		print("ERROR: fish_dir=" + str(fish_dir))
	# Defino tamano en base a profundidad
	fish_instance.char_size = Global.player_size + ((randi()%2)*2)-1; 
	# Hago aparecer fish_instance
	char_container_node.add_child(fish_instance); 


func switch_music():
	Global.music_on = not Global.music_on; 
	AudioServer.set_bus_mute(0, not Global.music_on); 


func update_border_colors():
	# Recorro todos los personajes en el nodo chars
	for curr_ch in char_container_node.get_children():
		curr_ch.update_border_color(); 


func _on_ui_exit_game():
	get_tree().change_scene_to_file(menu_res_path); 


func _on_player_size_change():
	ui_node.update_size(); 
	limits_node.update_limits(); 
	var camera_tween = get_tree().create_tween(); 
	var camera_newzoom = Vector2(Global.camera_zoom, Global.camera_zoom); 
	camera_tween.tween_property(camera_node, "zoom", camera_newzoom, Global.zoom_tweentime); 
	update_border_colors(); 


func _on_player_player_dead():
	get_tree().change_scene_to_file(menu_res_path); 


# Funcion para hacer aparecer peces
func _on_fish_spawn_timeout():
	spawn_fish(small_fish_scene); 
	spawn_fish(small_fish_scene); 
	spawn_fish(mid_fish_scene); 


func _on_ui_change_prof(p):
	prof = p; 
