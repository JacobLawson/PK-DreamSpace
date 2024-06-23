// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
enum BLENDMODES
{
	NORMAL,
	ADDATIVE,
	SUBTRACT,
	MULTIPLY,
	MAX, 
	SCREEN
}

function BattleBackgroundLayer(_sprite = noone) constructor
{
	sprite = 0;
	palette = spr_testPalette;
	blendMode = BLENDMODES.NORMAL;
	
	xAmplitude = 0.02;
	xWavelength = 32.0;
	xFrequency = 0.1;
	
	yAmplitude = 0.02;
	yWavelength = -100.0;
	yFrequency = 0.1;
	
	paletteTolerance = 0;
	
	scanLineOffset = 1.0;
	scanLineinterlaceModulator = 1.0;
	
	xScroll = 0;
	yScroll = 0;
	
}

