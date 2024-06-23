/// @description Insert description here
// You can write your code in this editor
time += 1;

//scroll editor
if (!dropDown_graphics_selected && !dropDown_blendMode_selected && !dropDown_palette_selected)
{
	if (mouse_wheel_up() && editorScroll < 0) { editorScroll += 32; }
	if (mouse_wheel_down()) { editorScroll -= 32; }
}

for (var i = 0; i < array_length(layerEditors); i++)
{
	var layerData = layers[i];
	var EditorData = layerEditors[i];
	var offset = 9;
	
	EditorData.xPos = 256 + offset;
	EditorData.yPos = (0 + 262 * i) + editorScroll;
	
	//set layerData based on Editior values
	layerData.sprite = EditorData.selectedSprite;
	layerData.palette = EditorData.selectedPalette;
	layerData.blendMode = EditorData.blendMode; 
	
	#region layer panel management
	
	//add panel
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + EditorData.xSize + 8, EditorData.yPos + 16, EditorData.xPos + EditorData.xSize + 8 + 32, EditorData.yPos + 16 + 32))
	{
		if (mouse_check_button_pressed(mb_left))
		{
			array_insert(layers, i+1, new BattleBackgroundLayer(sprBattleBG_1));
			array_insert(layerEditors, i+1, new BattleBackgroundLayer_Editor());
		}
	}
	//remove panel
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + EditorData.xSize + 12 + 32, EditorData.yPos + 16, EditorData.xPos + EditorData.xSize + 12 + 32 + 32, EditorData.yPos + 16 + 32))
	{
		if (mouse_check_button_pressed(mb_left) && array_length(layers) > 1)
		{
			array_delete(layers, i, 1);
			array_delete(layerEditors, i, 1);
		}
	}
	//move up
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + EditorData.xSize + 16 + 64, EditorData.yPos + 16, EditorData.xPos + EditorData.xSize + 16 + 64 + 32, EditorData.yPos + 16 + 32))
	{
		if (mouse_check_button_pressed(mb_left) && i > 0)
		{
			var iL = layers[i];
			var iE = layerEditors[i];
			layers[i] = layers[i-1];
			layerEditors[i] = layerEditors[i-1];
			layers[i-1] = iL;
			layerEditors[i-1] = iE;
		}
	}
	//move down
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + EditorData.xSize + 20 + 96, EditorData.yPos + 16, EditorData.xPos + EditorData.xSize + 20 + 96 + 32, EditorData.yPos + 16 + 32))
	{
		if (mouse_check_button_pressed(mb_left) && i < array_length(layers)-1)
		{
			var iL = layers[i];
			var iE = layerEditors[i];
			layers[i] = layers[i+1];
			layerEditors[i] = layerEditors[i+1];
			layers[i+1] = iL;
			layerEditors[i+1] = iE;
		}
	}
	
	#endregion
	
	//Itterate Sliders
	#region sliders
	for (var j = 0; j < array_length(EditorData.controlSliders); j++)
	{
		var slider = EditorData.controlSliders[j];
		
		//set slider position
		slider.xPos = EditorData.xPos + 112;
		slider.yPos = EditorData.yPos + 16 + (24*j);
		
		var distanceOnBar_check = slider.xSlider - slider.xPos;
		var percentageOnBar_check = distanceOnBar_check/slider.barLength;
		while (slider.val != lerp(slider.minimum, slider.maximum, percentageOnBar_check))
		{
			slider.xSlider += 0.01;
			distanceOnBar_check = slider.xSlider - slider.xPos;
			percentageOnBar_check = distanceOnBar_check/slider.barLength;
		}
		
		slider.xSlider = clamp(slider.xSlider, slider.xPos, slider.xPos + slider.barLength);
	
		//slider controls
		if (point_in_rectangle(mouse_x, mouse_y, slider.xSlider-4, slider.yPos-8, slider.xSlider+4, slider.yPos+8))
		{
			if (mouse_check_button(mb_left)) { slider.selected = true; }		
		}
	
		if (mouse_check_button(mb_left) && slider.selected) {
			slider.xSlider = clamp(mouse_x, slider.xPos, slider.xPos + slider.barLength);
		
			var distanceOnBar = slider.xSlider - slider.xPos;
			var percentageOnBar = distanceOnBar/slider.barLength;
			slider.val = lerp(slider.minimum, slider.maximum, percentageOnBar)
		}
		else if (slider.selected) {
			slider.selected = false;
		}
	}
	
	layerData.xAmplitude = EditorData.controlSliders[0].val;
	layerData.xWavelength = EditorData.controlSliders[1].val;
	layerData.xFrequency = EditorData.controlSliders[2].val;
	layerData.yAmplitude = EditorData.controlSliders[3].val;
	layerData.yWavelength = EditorData.controlSliders[4].val;
	layerData.yFrequency = EditorData.controlSliders[5].val;
	layerData.paletteTolerance = EditorData.controlSliders[6].val;
	layerData.scanLineOffset = EditorData.controlSliders[7].val;
	layerData.scanLineinterlaceModulator = EditorData.controlSliders[8].val;
	
	#endregion
	
	#region Graphic drop down
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos, EditorData.yPos + offset, EditorData.xPos + 64, EditorData.yPos +64))
	{
		if (mouse_check_button_pressed(mb_left)) 
		{ 
			if (!dropDown_graphics_selected)
			{
				dropDown_blendMode_selected = false;
				EditorData.spriteDropDown = !EditorData.spriteDropDown; 
				dropDown_graphics_selected = EditorData.spriteDropDown;
				dropDown_ox = EditorData.xPos;
				dropDown_oy = EditorData.yPos;
			}
			else
			{
				EditorData.spriteDropDown = false; 
				EditorData.blendDropDown = false; 
				dropDown_graphics_selected = false;
				dropDown_blendMode_selected = false;
				dropDown_scroll = 0;
			}
		}
	}
	
	if (EditorData.spriteDropDown) 
	{
		for (var j = 0; j < array_length(graphics); j++)
		{			
			var sprite_gap = 64;
			if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos, ((EditorData.yPos + offset + 64)+dropDown_scroll)+sprite_gap*j, EditorData.xPos + 64, (EditorData.yPos + offset + 64*2)+sprite_gap*j))
			{
				if (mouse_check_button_pressed(mb_left)) {
					EditorData.selectedSprite = j;
					EditorData.spriteDropDown = false;
				}
			} 
		}
		if (mouse_wheel_down()) { 
			if (dropDown_scroll > (array_length(graphics) * -64)) {
				dropDown_scroll -= 32; 
			}
		}
		if (mouse_wheel_up()) { 
			if (dropDown_scroll < 0) {
				dropDown_scroll += 32; 
			}
		}
	}
	#endregion
	
	#region Blend Mode drop down
	//blend mode drop down
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + 2, EditorData.yPos + offset + EditorData.ySize-30, EditorData.xPos + 78, EditorData.yPos + offset + EditorData.ySize-14))
	{
		if (mouse_check_button_pressed(mb_left))
		{
			if (!dropDown_blendMode_selected)
			{
				dropDown_graphics_selected = false;
				EditorData.blendDropDown = !EditorData.blendDropDown; 
				dropDown_blendMode_selected = EditorData.blendDropDown;
				dropDown_ox = EditorData.xPos + 2;
				dropDown_oy = EditorData.yPos + EditorData.ySize-76;
			}
			else
			{
				EditorData.spriteDropDown = false; 
				EditorData.blendDropDown = false; 
				dropDown_graphics_selected = false;
				dropDown_blendMode_selected = false;
				dropDown_scroll = 0;
			}	
		}
	}
	
	if (EditorData.blendDropDown)
	{
		for (var j = 0; j < array_length(blendModeOptions); j++)
		{
			var sprite_gap = 16;
			if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + 2, (EditorData.yPos + offset + EditorData.ySize-30)+16+sprite_gap*j, EditorData.xPos + 78, (EditorData.yPos + offset + EditorData.ySize-14)+16+sprite_gap*j))
			{
				if (mouse_check_button_pressed(mb_left)) {
					EditorData.blendMode = j;
					EditorData.blendDropDown = false;
				}
			}
		}
	}
	#endregion
	
	
	#region palette Drop down
	if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + 96, EditorData.yPos + offset + EditorData.ySize-30, EditorData.xPos + 238, EditorData.yPos + offset + EditorData.ySize-14))
	{
		if (mouse_check_button_pressed(mb_left))
		{
			if (!dropDown_palette_selected)
			{
				dropDown_graphics_selected = false;
				dropDown_blendMode_selected = false;
				EditorData.paletteDropDown = !EditorData.paletteDropDown; 
				dropDown_palette_selected = EditorData.paletteDropDown;
				dropDown_ox = EditorData.xPos + 2;
				dropDown_oy = EditorData.yPos + EditorData.ySize-76;
			}
			else
			{
				EditorData.spriteDropDown = false;
				EditorData.paletteDropDown = false;
				EditorData.blendDropDown = false; 
				dropDown_graphics_selected = false;
				dropDown_blendMode_selected = false;
				dropDown_palette_selected = false;
				dropDown_scroll = 0;
			}	
		}
	}
	
	if (EditorData.paletteDropDown)
	{
		for (var j = 0; j < array_length(palettes); j++)
		{
			var sprite_gap = 16;
			if (point_in_rectangle(mouse_x, mouse_y, EditorData.xPos + 96, (EditorData.yPos + offset + EditorData.ySize-30)+16+sprite_gap*j, EditorData.xPos + 238, (EditorData.yPos + offset + EditorData.ySize-14)+16+sprite_gap*j))
			{
				if (mouse_check_button_pressed(mb_left)) {
					EditorData.selectedPalette = palettes[j];
					EditorData.paletteDropDown = false;
				}
			}
		}
		if (mouse_wheel_down()) { 
			if (dropDown_scroll > (array_length(palettes) * -32)) {
				dropDown_scroll -= 32; 
			}
		}
		if (mouse_wheel_up()) { 
			if (dropDown_scroll < 0) {
				dropDown_scroll += 32; 
			}
		}
	}
	#endregion
}

