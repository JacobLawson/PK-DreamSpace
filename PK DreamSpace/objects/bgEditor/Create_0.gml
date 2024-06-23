/// @description Insert description here
// You can write your code in this editor
time = 0;
wavelength = 32.0;
amplitude = 0.02;
frequency = 0.1;
dir = 0;

previewSurface = surface_create(256, 256);
graphicIconSurface = surface_create(64, room_height);
paletteIconSurface = surface_create(256, room_height);
blendModeSurface = surface_create(96, room_height);

graphics = InitBackgroundGraphics();

palettes = [
	noone,
	spr_testPalette
]

blendModeOptions = [
	"Normal",
	"Addative",
	"Subtract",
	"Multiply",
	"Max",
	"Screen"
]

layers = [ 
	new BattleBackgroundLayer(),
	new BattleBackgroundLayer()
]

//layerEditor

dropDown_graphics_selected = false;
dropDown_blendMode_selected = false;
dropDown_palette_selected = false;
dropDown_ox = 0;
dropDown_oy = 0;
dropDown_scroll = 0;

editorScroll = 0;

xAmplitudeSliderSelected = false;

layerEditors = EditorRefresh(layers);