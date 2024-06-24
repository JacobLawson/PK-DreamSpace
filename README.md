# PK DreamSpace
A Video Drug background editor for GameMaker Studio 2
version 1.2.0

PK DreamSpace is a tool I've written to generate video drug backgrounds like those featured in the EarthBound/Mother series. These backgrounds can be exported into a JSON format for use in external projects that use my layered background format.

# Current features
- Saving and loading background JSON files.
- Add and remove an unlimited number of fully controllable layers.
- Control how layers blend together with Blend Mode controls.
- Scan line interlacing effect with variable control.
- Fully controllable sine wave effects.
- Palette controls.
- Full screen visualizer.
- GIF recording.

# Future plans
- Scrolling effects.
- Custom scripting for animations and improved palette swapping.
- Load new sprites and palettes from files (currently editing source is required).

# implementing PK DreamSpace in your projects
To implement PK DreamSpace include the following scripts in your project
- pk_background
- pk_DreamSpace

These two script files contain all the structs and functions required to load and draw PK DreamSpace exported backgrounds in your project. For an example of how to use these functions see objViewer.
