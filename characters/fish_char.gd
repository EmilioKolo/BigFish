extends "res://character.gd"

@onready var player_collider_node = get_node("player_collision"); 


func _ready():
	# Inicializo state como MOVING
	state = IDLE; 
	# Seteo velocidad del personaje
	char_speed = 3000; 
	# Actualizo tamano en base a scale_mult
	update_scale(); 
	update_border_color(); 


func apply_offset():
	if direction[0] == 0:
		# Cambio el valor de offset
		sprites_node.offset.x = offset_x*int(bool_x)*scale.x; 
		# Muevo detect_node porque no se mueve solo
		collision_node.position.x = offset_x*int(bool_x)*scale.x; 
		# Muevo player_collider_node porque no se mueve solo
		player_collider_node.position.x = offset_x*int(bool_x)*scale.x; 
	## Para variar en eje y
	if direction[1] == 0:
		# Cambio el valor de offset
		sprites_node.offset.y = offset_y*int(bool_y)*scale.y; 
		# Muevo detect_node porque no se mueve solo
		collision_node.position.y = offset_y*int(bool_y)*scale.y; 
		# Muevo player_collider_node porque no se mueve solo
		player_collider_node.position.y = offset_y*int(bool_y)*scale.y; 


func check_limit():
	if position.x > Global.limit_x[1]+Global.kill_offset:
		queue_free(); 
	elif position.x < Global.limit_x[0]-Global.kill_offset:
		queue_free(); 
	elif position.y > Global.limit_y[1]+Global.kill_offset:
		queue_free(); 
	elif position.y < Global.limit_y[0]-Global.kill_offset:
		queue_free(); 


func idle_state(delta):
	# Veo que global_position no pase Global.limit 
	check_limit(); 
	# Aumento velocity en base a speed y direction
	velocity.x = direction[0]*char_speed*delta * Global.camera_scale; 
	velocity.y = direction[1]*char_speed*delta * Global.camera_scale; 


func _on_player_collision_body_entered(body):
	# Veo que el cuerpo entrado sea player
	if body.name == "player":
		if body.char_size > self.char_size:
			state = DEAD; 
			# Uso eat_fish() 
			body.eat_fish(char_size); 
			queue_free(); 
		else:
			body.damage(char_size); 
