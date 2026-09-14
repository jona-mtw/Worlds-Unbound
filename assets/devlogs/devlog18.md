# Devlog 18 - I am happy once again!!

I FINALLY got the collisions to work!!

Basically, it looks at the terrain model that is imported into Godot, and aligns the vertices of the `CollisionShape3D` with it. It also updates its position every time the player moves 1 unit (whatever the size of a quad of the mesh is). Then it looks at the heightmap, looks up the height of its coresponding pixel, multiplies that by the height shader param (2000, like in the vertex shaders), and thats the collision shape done.

I noticed while walking around the world, that there were these massive ridges on the terrain. This is due to the lack of precision in the heightmap. The heightmap only has 256 shades of grey, and I need 2000 values. It is quite impossible to make a image file with that much precision, so instead, I'll make it so that the CPU will just send an array to the vertex shader.