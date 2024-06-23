// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function EditorRefresh(a_layers)
{
	if (array_length(a_layers) <= 0) { return; }
	
	var _editorLayers = array_create(array_length(a_layers));
	
	for (var i = 0; i < array_length(a_layers); i++)
	{
		var temp = new BattleBackgroundLayer_Editor();
		temp.selectedSprite = a_layers[i].sprite;
		temp.blendMode = a_layers[i].blendMode;
		temp.selectedPalette = a_layers[i].palette;
		
		var slider = noone;
		
		slider = temp.controlSliders[0]
		slider.val = a_layers[i].xAmplitude;
		
		temp.controlSliders[1].val = a_layers[i].xWavelength;
		temp.controlSliders[2].val = a_layers[i].xFrequency;
		
		temp.controlSliders[3].val = a_layers[i].yAmplitude;
		temp.controlSliders[4].val = a_layers[i].yWavelength;
		temp.controlSliders[5].val = a_layers[i].yFrequency;
		
		temp.controlSliders[6].val = a_layers[i].paletteTolerance;
		
		temp.controlSliders[7].val = a_layers[i].scanLineOffset;
		temp.controlSliders[8].val = a_layers[i].scanLineinterlaceModulator;
		
		_editorLayers[i] = temp;
	}
	return _editorLayers;
	
}