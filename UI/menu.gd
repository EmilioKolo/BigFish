extends Control

# Path de la escena de world
var world_res_path = "res://world/world.tscn"; 

# Variables que contienen nodos para importar
@onready var bgmusic_node = get_node("bgmusic"); 
@onready var sound_button = get_node("HBoxContainer/VBoxDerecha/MarginContainer2/Sonido"); 


func _ready():
	update_sound_button(); 


# Funcion para ver input todos los frames
func _input(_event):
	# Al apretar escape se cierra el juego
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit(); 
	if Input.is_action_just_pressed("sound"):
		switch_music(); 


func switch_music():
	Global.music_on = not Global.music_on; 
	AudioServer.set_bus_mute(0, not Global.music_on); 
	update_sound_button(); 


func update_sound_button():
	if Global.music_on:
		sound_button.text = "SONIDO ON"; 
	else:
		sound_button.text = "SONIDO OFF"; 


func _on_jugar_pressed():
	get_tree().change_scene_to_file(world_res_path); 


func _on_sonido_pressed():
	switch_music(); 
