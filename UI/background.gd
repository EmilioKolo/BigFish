extends ParallaxBackground


# Variables de profundidad
var profundidad = 10.0; 
var prof_max = 1000; 
var top_color = Color(0.1, 0.4, 1.0); 
var bot_color = Color(0.0, 0.0, 0.2); 

# Variables de parallax
var parallax_speed = Vector2(20, 5); 
var y_mirror = 2000; 
var x_mirror = 1671; 

# Agarro nodos
@onready var water_node = get_node("water"); 
@onready var terrain_node1 = get_node("terrain1"); 
@onready var terrain_node1_sprite = get_node("terrain1/Sprite2D"); 
@onready var terrain_node2 = get_node("terrain2"); 
@onready var terrain_node2_sprite = get_node("terrain2/Sprite2D"); 
@onready var terrain_node3 = get_node("terrain3"); 
@onready var terrain_node3_sprite = get_node("terrain3/Sprite2D"); 

# Defino senales
signal act_prof(p)


# Para llamar todos los frames
func _process(delta):
	# Aumento profundidad
	if profundidad < prof_max:
		profundidad = profundidad+delta*10; 
		act_prof.emit(int(profundidad)); 
		color_profundidad(); 
	# Muevo las cosas en parallax
	scroll_base_offset -= parallax_speed * delta; 


# Funcion para cambiar el color del fondo de acuerdo a la profundidad
func color_profundidad():
	# Porcentaje de profundidad
	var porc_prof = 100-int((profundidad/prof_max)*100); 
	var porc_top = (clamp(porc_prof+20, 0, 100))/100.0; 
	var porc_bot = (clamp(porc_prof-20, 0, 100))/100.0; 
	# Colores usados en top y bot de acuerdo a porc_prof
	var top_used = color_rango(top_color, bot_color, porc_top); 
	var bot_used = color_rango(top_color, bot_color, porc_bot); 
	water_node.texture.gradient.set_color(1, top_used); 
	water_node.texture.gradient.set_color(0, bot_used); 

# Funcion para interpolar entre dos colores usando num_rango()
func color_rango(c_top, c_bot, porc):
	return Color(num_rango(c_top.r, c_bot.r, porc), num_rango(c_top.g, c_bot.g, porc), num_rango(c_top.b, c_bot.b, porc))

# Funcion para interpolar entre dos numeros
func num_rango(n_top, n_bot, porc):
	# Pensado para n_top y n_bot entre 0.0 y 1.0
	# Porc es valor porcentual entre 0.0 y 1.0
	return ((n_top-n_bot)*porc)+n_bot


