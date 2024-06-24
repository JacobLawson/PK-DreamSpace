  #region DRAW PREVIEW
if (!surface_exists(previewSurface))
{
	previewSurface = surface_create(256, 256);	
}
surface_set_target(previewSurface);
gpu_set_tex_repeat(true);
shader_set(Shader1);

//draw layers
for (var i = 0; i < array_length(layers); i++)
{
	var layerData = layers[i];
	if (layerData == noone) { continue; }
	
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
	
	
	shader_set_uniform_f(uTime, time);
	shader_set_uniform_f(uAmplitude_x, layerData.xAmplitude);
	shader_set_uniform_f(uWavelength_x, layerData.xWavelength);
	shader_set_uniform_f(uFrequency_x, layerData.xFrequency);
	shader_set_uniform_f(uAmplitude_y, layerData.yAmplitude);
	shader_set_uniform_f(uWavelength_y, layerData.yWavelength);
	shader_set_uniform_f(uFrequency_y, layerData.yFrequency);
	shader_set_uniform_f(uLineOffset, layerData.scanLineOffset);
	shader_set_uniform_f(uLineMod, layerData.scanLineinterlaceModulator); 
	
	if (layerData.palette != noone)
	{
		var height = sprite_get_height(layerData.palette);
		var paletteTexture = sprite_get_texture(layerData.palette, 0);
		var paletteCoords = texture_get_uvs(paletteTexture);
		var size_w = texture_get_texel_width(paletteTexture);
		var size_h = texture_get_texel_height(paletteTexture);
		var tolerance = layerData.paletteTolerance;
		
		var paletteIndex = 0 mod (height-1);
		
		texture_set_stage(uPalette, paletteTexture);
		shader_set_uniform_f(uPaletteCoords, paletteCoords[0], paletteCoords[1], paletteCoords[2], paletteCoords[3]);
		shader_set_uniform_f(uPaletteSize, size_w, size_h);
		shader_set_uniform_f(uPaletteIndex, paletteIndex + 1);
		shader_set_uniform_f(uPaletteTolerance, tolerance);
	}
		
	draw_sprite(graphics[layerData.sprite], 0, 0, 0);
	
	//set blendmode
	switch(layerData.blendMode) {
		case BLENDMODES.NORMAL: gpu_set_blendmode(bm_normal); break;
		case BLENDMODES.ADDATIVE: gpu_set_blendmode(bm_add); break;
		case BLENDMODES.SUBTRACT: gpu_set_blendmode(bm_subtract); break;
		case BLENDMODES.MULTIPLY: gpu_set_blendmode_ext(bm_dest_color, bm_zero); break;
		case BLENDMODES.MAX: gpu_set_blendmode(bm_max); break;
		case BLENDMODES.SCREEN: gpu_set_blendmode_ext(bm_one, bm_inv_src_color); break;
	}
}
shader_reset();
gpu_set_blendmode(bm_normal);
surface_reset_target();
 
draw_surface(previewSurface, 8, 8);
#endregion

#region Draw Editor
for (var i = 0; i < array_length(layerEditors); i++)
{
	var layerEditor = layerEditors[i]; 
	var offset = 9;
	
	//border
	draw_set_color(c_black);
	draw_rectangle(layerEditor.xPos, layerEditor.yPos + offset, layerEditor.xPos + layerEditor.xSize, layerEditor.yPos + layerEditor.ySize, true);
	draw_set_color(c_white);
	
	//selected graphic preview
	#region DRAW GRAPHIC DROPDOWNS
	draw_sprite_ext(graphics[layerEditor.selectedSprite], 0, layerEditor.xPos, layerEditor.yPos+offset, 0.25, 0.25, 0, c_white, 1);
	//sprite dropdown
	if (layerEditor.spriteDropDown) 
	{
		if (!surface_exists(graphicIconSurface)) { graphicIconSurface = surface_create(64, room_height); }
		surface_set_target(graphicIconSurface)
		for (var j = 0; j < array_length(graphics); j++)
		{
			var sprite_gap = 64;
			draw_sprite_ext(graphics[j], 0, 0, (0+sprite_gap*j)+dropDown_scroll, 0.25, 0.25, 0, c_white, 1);	
		}
		surface_reset_target();
	}
	#endregion
	
	
	//palette drop down
	#region DRAW PALETTE DROPDOWNS
	draw_set_color(c_ltgray);
	draw_rectangle(layerEditor.xPos + 96, layerEditor.yPos + offset + layerEditor.ySize-30, layerEditor.xPos + 238, layerEditor.yPos + offset + layerEditor.ySize-14, false)
	draw_set_color(c_black);
	draw_rectangle(layerEditor.xPos + 96, layerEditor.yPos + offset + layerEditor.ySize-30, layerEditor.xPos + 238, layerEditor.yPos + offset + layerEditor.ySize-14, true)
	
	var paletteName = "NONE";
	if (layerEditor.selectedPalette != noone) { paletteName = sprite_get_name(layerEditor.selectedPalette); }
	draw_text(layerEditor.xPos + 96, layerEditor.yPos + offset + layerEditor.ySize-32, paletteName);
	draw_set_color(c_white); 
	
	if (layerEditor.paletteDropDown) 
	{
		if (!surface_exists(paletteIconSurface)) { paletteIconSurface = surface_create(96, room_height); }
		surface_set_target(paletteIconSurface)
		
		for (var j = 0; j < array_length(palettes); j++)
		{
			if (palettes[j] = noone) { paletteName = "NONE"; }
			else {
				paletteName = sprite_get_name(palettes[j]);
			}
			
			var tx = 1;
			var ty = 1;
			var bx = string_length(paletteName)*12;
			var by = 16;
			draw_set_color(c_ltgray);
			draw_rectangle(tx, ty+(by*j), bx, by+(by*j), false);
			draw_set_color(c_black);
			draw_rectangle(tx, ty+(by*j), bx, by+(by*j), true);
			draw_text(tx, (ty-2)+(by*j), paletteName);
			draw_set_color(c_white);
		}
		surface_reset_target();
	}
	
	
	#endregion
	
	
	//blendmode drop down
	#region Draw BLEND MODE DROPDOWNS
	draw_set_color(c_ltgray);
	draw_rectangle(layerEditor.xPos + 2, layerEditor.yPos + offset + layerEditor.ySize-30, layerEditor.xPos + 78, layerEditor.yPos + offset + layerEditor.ySize-14, false)
	draw_set_color(c_black);
	draw_rectangle(layerEditor.xPos + 2, layerEditor.yPos + offset + layerEditor.ySize-30, layerEditor.xPos + 78, layerEditor.yPos + offset + layerEditor.ySize-14, true)
	draw_text(layerEditor.xPos + 4, layerEditor.yPos + offset + layerEditor.ySize-32, blendModeOptions[layerEditor.blendMode]);
	draw_set_color(c_white); 
	
	if (layerEditor.blendDropDown) 
	{
		if (!surface_exists(blendModeSurface)) { blendModeSurface = surface_create(96, room_height); }
		surface_set_target(blendModeSurface)
		for (var j = 0; j < array_length(blendModeOptions); j++)
		{
			var tx = 1;
			var ty = 1;
			var bx = 77;
			var by = 16;
			draw_set_color(c_ltgray);
			draw_rectangle(tx, ty+(by*j), bx, by+(by*j), false);
			draw_set_color(c_black);
			draw_rectangle(tx, ty+(by*j), bx, by+(by*j), true);
			draw_text(tx, (ty-2)+(by*j), blendModeOptions[j]);
			draw_set_color(c_white);
		}
		surface_reset_target();
	}
	#endregion
	
	
	//draw sliders
	#region sliders
	for (var j = 0; j < array_length(layerEditor.controlSliders); j++)
	{
		var slider = layerEditor.controlSliders[j];
		
		draw_set_color(c_black);
		draw_set_halign(fa_right)
		draw_text(slider.xPos-4, slider.yPos-10, slider.minimum);
		draw_set_halign(fa_left)
		draw_text(slider.xPos + slider.barLength + 4, slider.yPos-10, slider.maximum);
		draw_text(slider.xPos + slider.barLength+40, slider.yPos-10, slider.label);
		draw_line(slider.xPos, slider.yPos, slider.xPos + slider.barLength, slider.yPos);
		draw_rectangle(slider.xSlider-4, slider.yPos-8, slider.xSlider+4, slider.yPos+8, false);
		draw_set_color(c_white);
	}
	#endregion
	
	
	#region other editor buttons
	
	//draw add button
	draw_sprite(spr_editor_buttons, 0, layerEditor.xPos + layerEditor.xSize + 8, layerEditor.yPos + 16);
	draw_sprite(spr_editor_buttons, 1, layerEditor.xPos + layerEditor.xSize + 12 + 32, layerEditor.yPos + 16);
	draw_sprite(spr_editor_buttons, 2, layerEditor.xPos + layerEditor.xSize + 16 + 64, layerEditor.yPos + 16);
	draw_sprite(spr_editor_buttons, 3, layerEditor.xPos + layerEditor.xSize + 20 + 96, layerEditor.yPos + 16);
	
	#endregion
}
#endregion

#region Draw Save/load

var buttonOffset_x = 8;
var buttonOffset_y = 272;
var buttonWidth = 48;
var buttonHeight = 24;
draw_set_color(c_grey)
draw_rectangle(buttonOffset_x, buttonOffset_y, buttonOffset_x + buttonWidth, buttonOffset_y + buttonHeight, false);
draw_set_color(c_black);
draw_rectangle(buttonOffset_x, buttonOffset_y,buttonOffset_x + buttonWidth, buttonOffset_y + buttonHeight, true);
draw_text(buttonOffset_x+2, buttonOffset_y+2, "Save");
draw_set_color(c_white);

draw_set_color(c_grey)
draw_rectangle(buttonOffset_x+64, buttonOffset_y, buttonOffset_x + buttonWidth + 64, buttonOffset_y + buttonHeight, false);
draw_set_color(c_black);
draw_rectangle(buttonOffset_x+64, buttonOffset_y,buttonOffset_x + buttonWidth + 64, buttonOffset_y + buttonHeight, true);
draw_text(buttonOffset_x+2+64, buttonOffset_y+2, "Load");
draw_set_color(c_white);

draw_set_color(c_grey)
draw_rectangle(buttonOffset_x+128, buttonOffset_y, buttonOffset_x + buttonWidth + 136, buttonOffset_y + buttonHeight, false);
draw_set_color(c_black);
draw_rectangle(buttonOffset_x+128, buttonOffset_y,buttonOffset_x + buttonWidth + 136, buttonOffset_y + buttonHeight, true);
draw_text(buttonOffset_x+2+128, buttonOffset_y+2, "Viewer");
draw_set_color(c_white);

#endregion

#region Draw Record
draw_sprite(spr_editor_buttons_record, recordingGIF, 216, 270);
#endregion