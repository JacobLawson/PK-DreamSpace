//draw layers
if (pkBackground == noone) { 
	draw_set_color(c_white);
	draw_set_font(fntViewer);
	draw_text(8, 0, "PRESS L TO LOAD BACKGROUND");
	draw_set_font(fntViewer);
	draw_text(8, 16, "PRESS BACKSPACE TO RETURN TO EDITOR");
	draw_set_font(fntDefault);
	exit; 
}

//surface
if (!surface_exists(background_surface)) {
	background_surface = surface_create(256, 256);	
}

pk_draw_background(pkBackground, backgroundCollection, time, background_surface);
