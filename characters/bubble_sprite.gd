extends Sprite2D

# Booleanos para definir rangos y dimensiones
@export var bool_x = true; 
@export var bool_y = true; 
@export var char_size = 10; 

# Offset de posicion inicial
var offset_x = randi_range(-10, 10); 
var offset_y = randi_range(-10, 10); 

# Direccion inicial
var dir_x = ((randi()%2)*2)-1; 
var dir_y = ((randi()%2)*2)-1; 

# Velocidad de offset
var offset_vel_x = randi_range(30, 40); 
var offset_vel_y = randi_range(30, 40); 

# Offset maximo
var max_offset_x = Vector2(randi_range(-25, -15), randi_range(15, 25)); 
var max_offset_y = Vector2(randi_range(-50, -21), randi_range(21, 50)); 

# Agarro nodo player_detect
@onready var detect_node = get_node("player_detect"); 


# Variables de movimiento
var direction = [0,0]; 
var speed = 200; 
var scale_dir = 1; 


func _ready():
	set_self_size(char_size, position); 


func _process(delta):
	check_limit(); 
	position.x = position.x + direction[0]*speed*delta; 
	position.y = position.y + direction[1]*speed*delta; 
	update_offset(delta); 


func check_limit():
	if direction==[1,0]:
		if global_position.x > Global.limit_x[1]:
			queue_free(); 
	elif direction==[-1,0]:
		if global_position.x < Global.limit_x[0]:
			queue_free(); 
	elif direction==[0,1]:
		if global_position.y > Global.limit_y[1]:
			queue_free(); 
	elif direction==[0,-1]:
		if global_position.y < Global.limit_y[0]:
			queue_free(); 


func update_offset(delta):
	# Defino modificador de velocidad en base a distancia a max_offset
	var speed_mod_x = 0; 
	var speed_mod_y = 0; 
	if dir_x>0:
		speed_mod_x = (max_offset_x.x-offset_x)/abs(max_offset_x.x);
	elif dir_x<0:
		speed_mod_x = (offset_x-max_offset_x.y)/abs(max_offset_x.y); 
	if dir_y>0:
		speed_mod_y = (max_offset_y.x-offset_y)/abs(max_offset_y.x);
	elif dir_y<0:
		speed_mod_y = (offset_y-max_offset_y.y)/abs(max_offset_y.y); 
	# Muevo los offset
	offset_x = offset_x + dir_x*max(0.1, offset_vel_x*speed_mod_x*delta); 
	offset_y = offset_y + dir_y*max(0.1, offset_vel_y*speed_mod_y*delta); 
	
	# Veo que offset no se pase del rango en max_offset
	if offset_x < max_offset_x.x:
		dir_x = 1; 
	elif offset_x > max_offset_x.y:
		dir_x = -1; 
	if offset_y < max_offset_y.x:
		dir_y = 1; 
	elif offset_y > max_offset_y.y:
		dir_y = -1; 
	# Cambio el valor de offset
	offset.x = offset_x*int(bool_x)*scale.x; 
	offset.y = offset_y*int(bool_y)*scale.y; 
	# Muevo detect_node porque no se mueve solo
	detect_node.position.x = offset_x*int(bool_x)*scale.x; 
	detect_node.position.y = offset_y*int(bool_y)*scale.y; 


# Funcion para hacer el zoom sin que se muevan tanto los personajes
func vector_zoom(self_pos, pos, scale_change):
	# Primero resto pos a self.position
	var shifted_pos = self_pos - pos; 
	# Despues multiplico por scale_change
	shifted_pos = shifted_pos * scale_change; 
	# Por ultimo, sumo pos
	shifted_pos = shifted_pos + pos; 
	return shifted_pos


func set_scale_dir(s):
	scale_dir = s; 


# Funcion para actualizar scale cuando aumenta el tamano de player
func set_self_size(n, pos):
	# Seteo char_size a n
	char_size = n; 
	# Almaceno el valor de scale anterior
	var prev_scale_x = float(scale.x); 
	var prev_scale_y = float(scale.y); 
	# Cambio scale segun el nuevo player_size
	scale.x = float(char_size)/Global.player_size; 
	scale.y = float(char_size)/Global.player_size; 
	# Defino cambio de escala
	var scale_change_x = scale.x/prev_scale_x; 
	var scale_change_y = scale.y/prev_scale_y; 
	# Defino distancia y direccion a pos
	self.global_position.x = vector_zoom(self.global_position.x, pos.x, scale_change_x); 
	self.global_position.y = vector_zoom(self.global_position.y, pos.y, scale_change_y); 


func _on_player_detect_body_entered(body):
	# Veo que el cuerpo entrado sea player
	if body.name == "player":
		body.eat_fish(0); 
		queue_free(); 

