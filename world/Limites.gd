extends Node2D

# Agarro los nodos
@onready var top_limit = get_node("Techo"); 
@onready var bot_limit = get_node("Suelo"); 
@onready var left_limit = get_node("Izquierda"); 
@onready var right_limit = get_node("Derecha"); 


func tween_limit(tweened_node, newpos, newscale): 
	var tween_pos = get_tree().create_tween(); 
	var tween_scale = get_tree().create_tween(); 
	tween_pos.tween_property(tweened_node, "position", newpos, Global.zoom_tweentime); 
	tween_scale.tween_property(tweened_node, "scale", newscale, Global.zoom_tweentime); 


func update_limits():
	# Uso tween para mover los limites lentamente
	# Actualizo limites usando position y scale
	# Arriba
	#top_limit.position.y = Global.limit_y.x; 
	#top_limit.scale.x = Global.camera_scale; 
	var top_newpos = Vector2(top_limit.position.x, Global.limit_y.x); 
	var top_newscale = Vector2(Global.camera_scale, top_limit.scale.y); 
	tween_limit(top_limit, top_newpos, top_newscale); 
	# Abajo
	#bot_limit.position.y = Global.limit_y.y; 
	#bot_limit.scale.x = Global.camera_scale; 
	var bot_newpos = Vector2(bot_limit.position.x, Global.limit_y.y); 
	var bot_newscale = Vector2(Global.camera_scale, bot_limit.scale.y); 
	tween_limit(bot_limit, bot_newpos, bot_newscale); 
	# Izquierda
	#left_limit.position.x = Global.limit_x.x; 
	#left_limit.scale.y = Global.camera_scale; 
	var left_newpos = Vector2(Global.limit_x.x, left_limit.position.y); 
	var left_newscale = Vector2(left_limit.scale.x, Global.camera_scale); 
	tween_limit(left_limit, left_newpos, left_newscale); 
	# Derecha
	#right_limit.position.x = Global.limit_x.y; 
	#right_limit.scale.y = Global.camera_scale; 
	var right_newpos = Vector2(Global.limit_x.y, right_limit.position.y); 
	var right_newscale = Vector2(right_limit.scale.x, Global.camera_scale); 
	tween_limit(right_limit, right_newpos, right_newscale); 
