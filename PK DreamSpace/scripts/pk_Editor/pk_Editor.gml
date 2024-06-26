function BattleBackgroundLayer_Editor() constructor
{
	xPos = 272;
	yPos = 0;
	xSize = 496;
	ySize = 262;
	
	selectedSprite = 0;
	selectedPalette = noone;
	blendMode = 0;
	
	spriteDropDown = false;
	paletteDropDown = false;
	blendDropDown = false;
	
	controlSliders = [
		new Slider("Xamplitude", -1, 1, 0),
		new Slider("Xwavelength", -128, 128, 0),
		new Slider("Xfrequency", 0, 1, 0),
		
		new Slider("Yamplitude", -1, 1, 0),
		new Slider("Ywavelength", -128, 128, 0),
		new Slider("Yfrequency", 0, 1, 0),
		
		new Slider("paletteTolerance", 0, 1, 0),
		
		new Slider("scanLineOffset", 0.0, 16, 0.0),
		new Slider("interlaceModulator", 1.0, 16, 1.0)
	];
}

function Slider(_label, _minimum, _maximum, _value) constructor
{
	selected = false;
	
	xPos = 0;
	yPos = 0;
	barLength = 128
	
	xSlider = 0;
	
	label = _label;
	minimum = _minimum;
	maximum = _maximum;
	val = _value;
}