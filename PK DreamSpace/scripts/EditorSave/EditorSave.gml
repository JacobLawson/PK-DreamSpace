// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function EditorSave(a_bgLayers = [], a_fileName = "vdbExport.json")
{
	//error handling
	if (array_length(a_bgLayers) <= 0) { 
		show_debug_message("No layers exist");
		return;
	}
	
	file = get_save_filename("vdbExport|*.json", a_fileName);

	
	var _json = json_stringify(a_bgLayers, true);
	
	//save to file
	var buffer = buffer_create(string_byte_length(_json) + 1, buffer_fixed, 1);
	buffer_write(buffer, buffer_string, _json);
	buffer_save(buffer, file);
	buffer_delete(buffer);
}