# Assignment 4 - Gravity Modified

This project requires the PostFX library for Processing, which can be found here:
https://github.com/cansik/processing-postfx

The project was made using Daniel Shiffman's "What is a Force" tutorial on YouTube and the "BouncyBubbles" example on Processing.org as guidelines. The collision algorithm is essentially identical to the one found in the example, however it has been adapted slightly to 1) work with the attributes of the ball object and 2) work with 3D collisions as well as 2D.

My motivation for this 3D modification was the want to eventually make a 3D "Pong" game – perhaps in VR. Handling collisions in 3D space is an all-around interesting topic to me, and this seemed like a good place to test out some possibilities.

When the program starts, click anywhere to release the ball objects from their starting position. Click anywhere to add more balls. Press '3' to transition between 3D and 2D view modes. You can press 'R' at any time to reset the balls at their starting positions, then click again to give them new velocities.