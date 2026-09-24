# Devlog 19 - Main Menu Added (and other things)!

I spent quite a lot of time making the background for the main menu in Blender. After just copy and pasting the player model used in the game, I went ahead and made the main attraction: :sparkle: the planet in the background :sparkle:.

My knowledge of noise that I gained from my previous attempts at the terrain generation helped me create the stars in the background, and the texture for the actual planet in the shader editor. I also added a slight atmosphere, which is (somewhat?) noticeable.

I also went ahead and updated the shader code. Before, I used to use the visual shaders, since it was quite similar to the shader editor in Blender, which I was familiar with. But then I realised there's just more flexibility with using `GLSL`. I can group uniforms in the inspector, making it clearer and less cluttered if I want to add textures in the future, including different images for the same texture (like Ambient Occlusion, Normals, Colours, and Roughness). Thus being able to group those different types images for the same texture was very important for future usability.

Thankfully, Godot allows you to see the shader code that is generated from the visual shaders. Unfortunately, it was not readable at all. The generated code used a random(ish) collection of numbers and letters, and it was too long. Look below for the comparision, but it was something like 84 lines that was shruken down to 10. Even if you account for spaces in the generated code (which then it might be like 50-60 lines) thats a huge difference. So it took quite some time to get it to a readable state.
