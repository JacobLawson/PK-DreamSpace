// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function EditorLoad() {
	var file = get_open_filename("json|*.json", "");
	if (!file_exists(file)) { return layers; }
	var buffer = buffer_load(file);
	var _json = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	
	return json_parse(_json);
}