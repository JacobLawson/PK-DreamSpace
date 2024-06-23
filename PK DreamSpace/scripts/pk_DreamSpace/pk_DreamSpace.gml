// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function pk_draw_background(a_pkBG, a_graphics, a_time, a_surface = application_surface){

	surface_set_target(a_surface);
	gpu_set_tex_repeat(true);
	shader_set(Shader1);

	for (var i = 0; i < array_length(a_pkBG); i++)
	{
		var layerData = a_pkBG[i];
		if (layerData == noone) { continue; }
		
		pk_draw_layer(layerData, a_graphics, a_time)
	}
	shader_reset();
	gpu_set_blendmode(bm_normal);
	surface_reset_target();
 
	draw_surface(a_surface, 0, 0);
}

function pk_draw_layer(a_layerData, a_graphics, a_time)
{
	//get shader uniforms
	var uTime = shader_get_uniform(Shader1, "uTime");
	var uAmplitude_x = shader_get_uniform(Shader1, "uAmplitude_x");
	var uWavelength_x = shader_get_uniform(Shader1, "uWavelength_x");
	var uFrequency_x = shader_get_uniform(Shader1, "uFrequency_x");
	var uAmplitude_y = shader_get_uniform(Shader1, "uAmplitude_y");
	var uWavelength_y = shader_get_uniform(Shader1, "uWavelength_y");
	var uFrequency_y = shader_get_uniform(Shader1, "uFrequency_y");
	var uLineOffset = shader_get_uniform(Shader1, "uLineOffset");
	var uLineMod = shader_get_uniform(Shader1, "uLineMod");
	
	var uPalette = shader_get_sampler_index(Shader1, "uPalette");
	var uPaletteCoords = shader_get_uniform(Shader1, "uPaletteCoords");
	var uPaletteSize = shader_get_uniform(Shader1, "uPaletteSize");
	var uPaletteIndex = shader_get_uniform(Shader1, "uPaletteIndex");
	var uPaletteTolerance = shader_get_uniform(Shader1, "uPaletteTolerance");
	
	
	shader_set_uniform_f(uTime, a_time);
	shader_set_uniform_f(uAmplitude_x, a_layerData.xAmplitude);
	shader_set_uniform_f(uWavelength_x, a_layerData.xWavelength);
	shader_set_uniform_f(uFrequency_x, a_layerData.xFrequency);
	shader_set_uniform_f(uAmplitude_y, a_layerData.yAmplitude);
	shader_set_uniform_f(uWavelength_y, a_layerData.yWavelength);
	shader_set_uniform_f(uFrequency_y, a_layerData.yFrequency);
	shader_set_uniform_f(uLineOffset, a_layerData.scanLineOffset);
	shader_set_uniform_f(uLineMod, a_layerData.scanLineinterlaceModulator); 
	
	if (a_layerData.palette != noone)
	{
		var height = sprite_get_height(a_layerData.palette);
		var paletteTexture = sprite_get_texture(a_layerData.palette, 0);
		var paletteCoords = texture_get_uvs(paletteTexture);
		var size_w = texture_get_texel_width(paletteTexture);
		var size_h = texture_get_texel_height(paletteTexture);
		var tolerance = a_layerData.paletteTolerance;
		
		var paletteIndex = 0 mod (height-1);
		
		texture_set_stage(uPalette, paletteTexture);
		shader_set_uniform_f(uPaletteCoords, paletteCoords[0], paletteCoords[1], paletteCoords[2], paletteCoords[3]);
		shader_set_uniform_f(uPaletteSize, size_w, size_h);
		shader_set_uniform_f(uPaletteIndex, paletteIndex + 1);
		shader_set_uniform_f(uPaletteTolerance, tolerance);
	}
		
	draw_sprite(a_graphics[a_layerData.sprite], 0, 0, 0);
	
	//set blendmode
	switch(a_layerData.blendMode) {
		case BLENDMODES.NORMAL: gpu_set_blendmode(bm_normal); break;
		case BLENDMODES.ADDATIVE: gpu_set_blendmode(bm_add); break;
		case BLENDMODES.SUBTRACT: gpu_set_blendmode(bm_subtract); break;
		case BLENDMODES.MULTIPLY: gpu_set_blendmode_ext(bm_dest_color, bm_zero); break;
		case BLENDMODES.MAX: gpu_set_blendmode(bm_max); break;
		case BLENDMODES.SCREEN: gpu_set_blendmode_ext(bm_one, bm_inv_src_color); break;
	}
}

function pk_load_background_from_file(a_fileName) {
	if (!file_exists(a_fileName)) 
	{ 
		show_debug_message("PK ERROR: Failed to find existing file " + a_fileName);
		return false; 
	}
	
	var buffer = buffer_load(a_fileName);
	var _json = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	
	return json_parse(_json);
}