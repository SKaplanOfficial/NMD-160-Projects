Stephen Kaplan
NMD 160
November 26th, 2018

StudioCanvas - Interactivity Project

Requirements:
- Android Mode for Processing
- LeapMotion Processing Library (https://github.com/nok/leap-motion-processing)
- LeapMotion Software (https://www.leapmotion.com/setup/desktop/)

The goals of this project were to make a shared canvas using the Processing Network Library, to provide a companion Processing Android application for use as a controller for the canvas, and to use the LeapMotion Controller as an alternate method of interaction with the canvas. I'm very glad to say that all of these goals were met! (Though I am aware that there is always room for improvement).

There are three components of the project: The server, the client, and the companion.

The server is very simple; it essential just relays messages from one client to all others. It also maintains the link between clients and their companions. The server is hosted on an AWS EC2 instance.

The client is a little less simple. It receives data in the form of a previous mouse position, a current mouse position, and a mode and translates it into a display. Each mode reacts to data in a specific way. Some will be create exactly the same display across all clients, while others will create nearly the same (ex: scatter). It is possible to achieve the same display across all devices, but it is, for the most part, unnecessary.

The companion is perhaps the most complex part. It allows users to control the colors and drawing tools of their client from a tablet, similar to how a painter would use a palette to select their colors while painting on a real canvas. To connect a companion, open the app and enter the code in the top left corner of a client.

Documentation Video:
https://youtu.be/NANE09a2RdU