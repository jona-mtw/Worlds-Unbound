# GPU noise (failed attempt)

I found a way to make noise using a Godot addon called `FastNoiseLite Runtime Shader`. It was apparently identical to the `FastNoiseLite` in GDScript. So I gave it a try. I knew it was a gamble, given how much time I got left to ship an decent project, but I gave it a try since it seemed interesting. It wasn't that hard to get the noise working, but to get it to sync with the collisions was a nightmare. In the end, I decided that even though the README stated it was 99.9% the same, the output seed by seed was different. So I decided to scrap it and now I'm going back to the old version with heightmaps. 

Why did I really want to switch?

Because of the limited colour depth in images (has to be 8-bit for GDShader to read), theres not enough heights for each vertex to be at, so every so often, there's this massive wall. It looks fine from afar, but thats probably because my terrain is 20km x 20km, so of course an 8m tall wall would look fine.
