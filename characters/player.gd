extends "res://character.gd"


# Gravedad de ProjectSettings para funcionar bien con RigidBody
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity"); 
var gravity_used = 0; 

# Contador de alimento
var feed_cont = 0; 

# Booleano para invulnerabilidad
@export var vulnerable = true; 

# Agarro nodos
@onready var damage_sound_node = get_node("damage_sound"); 
@onready var eat_sound_node = get_node("eat_sound"); 
@onready var grow_sound_node = get_node("grow_sound"); 
@onready var shrink_sound_node = get_node("shrink_sound"); 
@onready var lose_sound_node = get_node("lose_sound"); 


# Senales que emite
signal size_change
signal player_dead


func _ready():
	# Inicializo state como MOVING
	state = MOVING; 
	# Seteo velocidad del player
	char_speed = 300.0; 
	# Inicializo size 
	char_size = int(Global.base_player_size); 
	Global.update_player_size(Global.base_player_size); 


func damage(s):
	if vulnerable:
		# Disminuyo feed_cont en s
		feed_cont = feed_cont - s; 
		# Hago sonido de damage
		damage_sound_node.play(); 
		# Uso update_feed_cont() para ver si hay que aumentar o reducir tamano
		update_feed_cont(); 
		# Uso blink_node para dar invulnerabilidad
		blink_node.play("blink_on"); 


func death():
	# Cambio state a IDLE para no mover el personaje
	state = IDLE; 
	# Bajo velocidad a 0
	velocity.x = 0; 
	velocity.y = 0; 
	# anims_node resuelve el tema de muerte
	anims_node.play("dead"); 


func eat_fish(s):
	# Aumento feed_cont en s
	feed_cont = feed_cont + s; 
	# Hago sonido de eat
	eat_sound_node.play(); 
	# Uso update_feed_cont() para ver si hay que aumentar o reducir tamano
	update_feed_cont(); 


# Cambio la funcion de estado de movimiento
func moving_state(_delta):
	# Agarro direccion x e y
	var direction_x = Input.get_axis("left", "right"); 
	var direction_y = Input.get_axis("up", "down"); 
	# Normalizo para movimiento diagonal
	var direction_x_y = Vector2(direction_x, direction_y).normalized(); 
	# Reviso si direction_x o direction_y son distintos a 0
	if direction_x:
		velocity.x = direction_x * char_speed * abs(direction_x_y.x) * Global.camera_scale; 
	else:
		velocity.x = move_toward(velocity.x, 0, char_speed * Global.camera_scale); 
	if direction_y:
		velocity.y = direction_y * char_speed * abs(direction_x_y.y) * Global.camera_scale; 
	else:
		velocity.y = move_toward(velocity.y, 0, char_speed * Global.camera_scale); 
	# Uso move_and_slide() para mover en base a velocity
	move_and_slide(); 


func set_self_size(n):
	if n>1:
		char_size = n; 
		Global.update_player_size(n); 
		size_change.emit(); 
		var tween_scale = get_tree().create_tween(); 
		var player_newscale = Vector2(Global.camera_scale, Global.camera_scale); 
		tween_scale.tween_property(self, "scale", player_newscale, Global.zoom_tweentime); 
	else:
		death(); 


func update_feed_cont():
	# Veo si feed_cont es mayor a 2*char_size
	if feed_cont >= (2*char_size):
		# Ejecuto sonido de crecimiento una vez
		grow_sound_node.play(); 
		# Uso while para crecer varias veces si es necesario
		while feed_cont >= (2*char_size):
			# Achico feed_cont
			feed_cont = feed_cont - 2*char_size; 
			# Uso set_self_size() para agrandar char_size
			set_self_size(char_size+1); 
	# Veo si feed_cont es menor a 0
	elif feed_cont < 0:
		# Ejecuto sonido de achicamiento una vez
		shrink_sound_node.play(); 
		# Uso while para achicar varias veces si es necesario
		while feed_cont < 0:
			# Agrando feed_cont
			feed_cont = feed_cont + char_size; 
			# Uso set_self_size() para achicar char_size
			set_self_size(char_size-1); 

