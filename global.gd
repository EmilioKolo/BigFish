extends Node

# Tamano del player, afecta los demas personajes
var base_player_size = 5.0; 
var player_size = 5; 
# Variables de player
var player_max_hp = 4; 

# Limites del mapa
var viewport_limit_x = ProjectSettings.get_setting("display/window/size/viewport_width"); 
var viewport_limit_y = ProjectSettings.get_setting("display/window/size/viewport_height"); 
var kill_offset = 50; 

# Variables de camara
var limit_x:Vector2; 
var limit_y:Vector2; 
var camera_zoom = 1; 
var camera_scale = 1; 
var zoom_tweentime = 0.6; 

# Variables de sonido
var music_on = true; 


func _ready():
	update_player_size(base_player_size); 
	limit_x.x = 0; 
	limit_x.y = viewport_limit_x; 
	limit_y.x = 0; 
	limit_y.y = viewport_limit_y; 


# Funcion para actualizar el valor de limit_x y limit_y cuando cambia el zoom de la camara
func update_camera_zoom(new_zoom):
	# Registro el nuevo zoom
	camera_zoom = new_zoom; 
	# Paso zoom a scale haciendo 1/zoom
	camera_scale = 1.0/new_zoom; 
	# Defino el tamano esperado de la camara de acuerdo a new_scale y viewport_limit
	var new_size_x = viewport_limit_x*camera_scale; 
	var new_size_y = viewport_limit_y*camera_scale; 
	# Calculo la diferencia de tamano entre viewport_limit y new_size
	var dif_x = new_size_x - viewport_limit_x; 
	var dif_y = new_size_y - viewport_limit_y; 
	# Defino limit_x y limit_y poniendo dif_x/2 y dif_y/2 a cada lado de los limites
	limit_x.x = -dif_x/2; 
	limit_x.y = viewport_limit_x+dif_x/2; 
	limit_y.x = -dif_y/2; 
	limit_y.y = viewport_limit_y+dif_y/2; 


# Funcion para resolver el cambio de tamano de player
func update_player_size(new_size):
	player_size = new_size; 
	update_camera_zoom(base_player_size/new_size); 

