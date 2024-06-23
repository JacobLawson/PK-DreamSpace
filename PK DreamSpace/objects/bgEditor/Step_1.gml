/// @description Insert description here
// You can write your code in this editor
#region save/load
var buttonOffset_x = 8;
var buttonOffset_y = 272;
var buttonWidth = 48;
var buttonHeight = 24;

//save button
if (point_in_rectangle(mouse_x, mouse_y, buttonOffset_x, buttonOffset_y, buttonOffset_x + buttonWidth, buttonOffset_y + buttonHeight))
{
	if (mouse_check_button_pressed(mb_left))
	{
		//save data	
		EditorSave(layers);
	}
}

if (point_in_rectangle(mouse_x, mouse_y, buttonOffset_x + 64, buttonOffset_y, buttonOffset_x + buttonWidth + 64, buttonOffset_y + buttonHeight))
{
	if (mouse_check_button_pressed(mb_left))
	{
		//save data	
		layers = EditorLoad();
		layerEditors = EditorRefresh(layers);
		show_debug_message(layerEditors);
	}
}

if (point_in_rectangle(mouse_x, mouse_y, buttonOffset_x+128, buttonOffset_y, buttonOffset_x + buttonWidth + 136, buttonOffset_y + buttonHeight))
{
	if (mouse_check_button_pressed(mb_left))
	{
		surface_resize(application_surface, 256, 256);
		window_set_size(256, 256)
		room_goto(Viewer);
	}
}

#endregion



