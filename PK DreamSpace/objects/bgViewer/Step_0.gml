/// @description Insert description here
// You can write your code in this editor
if (keyboard_check_pressed(ord("L"))) { 
	var file = get_open_filename("json|*.json", "");
	pkBackground = pk_load_background_from_file(file);
	time = 0;
	
	if (surface_exists(background_surface)) { 
		surface_free(background_surface); 
	}

}

if (keyboard_check_pressed(vk_backspace)) {
	surface_resize(application_surface, 960, 540);
	window_set_size(960, 540)
	room_goto(Editor);	
}

if (pkBackground == noone) { exit; }
time++;

