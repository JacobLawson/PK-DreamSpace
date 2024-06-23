/// @description Insert description here
// You can write your code in this editor
if (surface_exists(graphicIconSurface) && dropDown_graphics_selected) {
	draw_surface(graphicIconSurface, dropDown_ox, (dropDown_oy+9+64))
}
else if (surface_exists(blendModeSurface) && dropDown_blendMode_selected) {
	draw_surface(blendModeSurface, dropDown_ox-1, (dropDown_oy+9+64))
}
else if (surface_exists(paletteIconSurface) && dropDown_palette_selected) {
	draw_surface(paletteIconSurface, dropDown_ox+93, (dropDown_oy+9+64))
}


 