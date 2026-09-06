# Devlog 16 - AMAZING PROGRESS!!

I've managed to get a massive 20km render distance with huge mountains and ridges using `FastNoiseLite` and vertex shaders. I used [devmar](https://www.youtube.com/watch?v=rcsIMlet7Fw)'s terrain technique, which he named the "Wandering Clipmap Terrain Technique". 

The reason why the technique is called the "*Wandering Clipmap* Terrain Technique" is because a flat plane that is subdivided a bunch (to make varrying levels of detail (LODs)) that follows the player. The vertex shaders then offset the heightmap so it gives off the illusions that your moving about in a massive world.

All the displacement is done by the vertex shaders, which looks at a heightmap. In the future, I might make this heightmap be generated in gdscript instead of in the inspector, to deal with texture resolutions. Currently, from afar, the terrain looks amazing (except from the fact its not textured) but upclose, you can see rings in the terrain, which is caused by the heightmap's resolution being too low. In fact each ring is about 8m tall so I really need to fix that :sob:

The normals are calculated by just copying the heightmap and setting it 'as normals' in the inspector. They also are multiplied by a `normal basis` matrix, which allows me to configure the specific normal settings. I'll need to calculate the normals in the fragment shader as well in the future for more convincing shadows, but for the mean time, the vertex shaders should do just fine.

I'm planning on adding collisions, then maybe textures, biomes and vegetation soon!!
