extends CharacterBody2D


# Variables del personaje
@export var char_size = 1; 
@export var scale_mult = 1.0; 
var health = 1; 
var char_speed = 200; 
var scale_dir = 1; 
var direction = [0,0]; 

# Variables para definir si se usa offset en x o en y
@export var bool_x = true; 
@export var bool_y = true; 
# Offset de posicion inicial
var offset_x = randi_range(-20, 20); 
var offset_y = randi_range(-10, 10); 
# Direccion inicial
var dir_x = ((randi()%2)*2)-1; 
var dir_y = ((randi()%2)*2)-1; 
# Velocidad de offset
var offset_vel_x = randi_range(40, 60); 
var offset_vel_y = randi_range(30, 50); 
# Offset maximo
var max_offset_x = Vector2(randi_range(-100, -51), randi_range(51, 100)); 
var max_offset_y = Vector2(randi_range(-50, -21), randi_range(21, 50)); 

# Nodos para llamar
@onready var sprites_node = get_node("sprites"); 
@onready var anims_node = get_node("animations"); 
@onready var blink_node = get_node("blinker"); 
@onready var collision_node = get_node("collision"); 

# Preparo los estados de character
enum {
	MOVING,
	IDLE,
	DEAD
}
var state = IDLE; 


func _ready():
	update_scale(); 
	update_border_color(); 


# Asigno physics process a funciones de estado
func _physics_process(delta):
	match state:
		IDLE:
			idle_state(delta); 
		MOVING:
			moving_state(delta); 
		DEAD:
			dead_state(); 
	# Hago el movimiento
	move_and_slide(); 


# Inicializo las funciones de estado vacias
func idle_state(_delta):
	pass

# Inicializo las funciones de estado vacias
func moving_state(_delta):
	pass

# Inicializo las funciones de estado vacias
func dead_state():
	pass

# Funcion para cambiar direccion del pez
func set_scale_dir(s):
	scale_dir = s; 


func apply_offset():
	if direction[0] == 0:
		# Cambio el valor de offset
		sprites_node.offset.x = offset_x*int(bool_x)*scale.x; 
		# Muevo detect_node porque no se mueve solo
		collision_node.position.x = offset_x*int(bool_x)*scale.x; 
	## Para variar en eje y
	if direction[1] == 0:
		# Cambio el valor de offset
		sprites_node.offset.y = offset_y*int(bool_y)*scale.y; 
		# Muevo detect_node porque no se mueve solo
		collision_node.position.y = offset_y*int(bool_y)*scale.y; 


func update_border_color():
	sprites_node.material.set_shader_parameter('line_thickness', 3);
	if Global.player_size > char_size:
		sprites_node.material.set_shader_parameter('line_color', Vector4(0.0, 1.0, 0.0, 1.0)); 
	else:
		sprites_node.material.set_shader_parameter('line_color', Vector4(1.0, 0.0, 0.0, 1.0)); 


func update_offset(delta):
	## Para variar en eje x
	if direction[0] == 0:
		# Defino modificador de velocidad en base a distancia a max_offset
		var speed_mod_x = 0; 
		if dir_x>0:
			speed_mod_x = (max_offset_x.x-offset_x)/abs(max_offset_x.x);
		elif dir_x<0:
			speed_mod_x = (offset_x-max_offset_x.y)/abs(max_offset_x.y); 
		# Muevo los offset
		offset_x = offset_x + dir_x*max(0.1, offset_vel_x*speed_mod_x*delta); 
		# Veo que offset no se pase del rango en max_offset
		if offset_x < max_offset_x.x:
			dir_x = 1; 
		elif offset_x > max_offset_x.y:
			dir_x = -1; 
	## Para variar en eje y
	if direction[1] == 0:
		# Defino modificador de velocidad en base a distancia a max_offset
		var speed_mod_y = 0; 
		if dir_y>0:
			speed_mod_y = (max_offset_y.x-offset_y)/abs(max_offset_y.x);
		elif dir_y<0:
			speed_mod_y = (offset_y-max_offset_y.y)/abs(max_offset_y.y); 
		# Muevo los offset
		offset_y = offset_y + dir_y*max(0.1, offset_vel_y*speed_mod_y*delta); 
		# Veo que offset no se pase del rango en max_offset
		if offset_y < max_offset_y.x:
			dir_y = 1; 
		elif offset_y > max_offset_y.y:
			dir_y = -1; 
	# Cambio offset por medio de una funcion
	apply_offset(); 


func update_scale():
	scale.x = scale_dir*scale_mult*char_size; 
	scale.y = scale_mult*char_size; 


# Funcion para actualizar scale cuando aumenta el tamano de player
#func set_self_size(n, pos):
	# Seteo char_size a n
#	char_size = n; 
	# Almaceno el valor de scale anterior
	#var prev_scale_x = float(scale.x); 
	#var prev_scale_y = float(scale.y); 
	# Cambio scale segun el nuevo player_size
#	scale.x = scale_mult*scale_dir*float(char_size)/Global.player_size; 
#	scale.y = scale_mult*float(char_size)/Global.player_size; 
	# Defino cambio de escala
	#var scale_change_x = scale.x/prev_scale_x; 
	#var scale_change_y = scale.y/prev_scale_y; 
