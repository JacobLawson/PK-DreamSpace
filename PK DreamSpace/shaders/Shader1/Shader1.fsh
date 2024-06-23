    varying vec2 v_vTexcoord;
    varying vec4 v_vColour;
	varying float v_vLine;
	
    uniform float uTime;
	
	//palette
	uniform sampler2D uPalette;
	uniform vec4 uPaletteCoords;
	uniform vec2 uPaletteSize;
	uniform float uPaletteIndex;
	uniform float uPaletteTolerance;
	
	//warping
    uniform float uAmplitude_x;
    uniform float uWavelength_x;
    uniform float uFrequency_x;
	
	uniform float uAmplitude_y;
    uniform float uWavelength_y;
    uniform float uFrequency_y; 
	
    uniform float uLineMod;
	
	void main() 
	{
		//Warping
        float DY = uAmplitude_y * sin(uWavelength_y * v_vTexcoord.y + uFrequency_y * uTime);  //(D)isplacement
		float DX = uAmplitude_x * sin(uWavelength_x * v_vTexcoord.x + uFrequency_x * uTime);  //(D)isplacement
        vec2 T = v_vTexcoord + vec2(DY, DX); //new (T)exture coordinates
		
		//Colour
		vec4 texColour = texture2D(gm_BaseTexture, T);
		vec4 outpuColour = texColour;	
		vec4 colour;
		
		for (float fx = uPaletteCoords.x; fx < uPaletteCoords.z; fx += uPaletteSize.x)
		{
			colour = texture2D(uPalette, vec2(fx, uPaletteCoords.y));
			if (distance(texColour, colour) <= uPaletteTolerance)
			{
				outpuColour = texture2D(uPalette, vec2(fx, uPaletteCoords.y + uPaletteSize.y * uPaletteIndex));
				break;
			}
		}
		
		float base_alpha = texture2D( gm_BaseTexture, T).a;
		gl_FragColor = vec4( v_vColour.rgb, mix(base_alpha * v_vColour.a, 0.0, mod(floor(v_vLine), uLineMod))) * outpuColour;
		//gl_FragColor = v_vColour * outpuColour;
    }