Stephen Kaplan
NMD 160
December 17th, 2018

   _____                       _    _   _      _                      _    
  / ____|                     | |  | \ | |    | |                    | |   
 | (___   ___  _   _ _ __   __| |  |  \| | ___| |___      _____  _ __| | __
  \___ \ / _ \| | | | '_ \ / _` |  | . ` |/ _ \ __\ \ /\ / / _ \| '__| |/ /
  ____) | (_) | |_| | | | | (_| |  | |\  |  __/ |_ \ V  V / (_) | |  |   < 
 |_____/ \___/ \__,_|_| |_|\__,_|  |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\
                                                                           
                                                                                                          

Description and Motivation -
Music visualization and networking have always been interesting to me. I wanted to combine them in a way that explores how devices we already have can be linked together to create a more impactful experience.

Last year I made a simple Processing client and server setup that would turn screens from light to dark in the order that the devices were connected. My friends and I were interested in how patterns could be made from that, so we gathered the devices we had access to and connected them to the server. Although the devices only went from light to dark with a timed delay, the concept was really interesting to me. That project can be found here:
https://github.com/SKaplanOfficial/Networking/tree/master/LightNetwork

This project is in many ways an extension of that concept, though it is also distinctly different. Devices still connect to a server and display visuals, but that visual is significantly more complex now, and on top of that the visual is controlled by music played on the server. Each connected device, apart from the controller tablet, has a slightly different visual to give a sense of the wide range of frequencies.

There are five visuals. Each visual was designed to introduce new ideas compared to the previous, so that the program in its current form is suited for explanation and discovery.



Dependencies -
This projects require the Minim library processing, which can be found by going to Sketch -> Import Library -> Add Library -> Search Minim -> Install. You might need to restart Processing before Minim works.

The net library is included by default in Processing Java, however for the Android version I have provided the net.jar file. There should be no issues when trying to use the net library on Android with this file, however I'm not sure this is the case with all versions of Processing. I developed and tested this project on Processing 3.3.6.

SoundServer can be run on any computer.
SoundClient can be run on any computer.
SoundController should be run on an Android tablet, but will also function on any computer.



Interaction - 
From the server, pressing keys 1-4 plays songs from the data folder. Pressing key 5 will switch to live audio input.

The controller has various controls that are labelled as follows:
Red, Green, Blue sliders -> Control colors
Set Background -> Set background to current color

Buttons 1, 2, 3, 4, 5 -> Different visuals

All other buttons -> Songs
The row of buttons starting with "Footprints" will not function outside of my in-class presentation. The other songs are freely downloadable from the following links:

Bensound Music:
https://www.bensound.com/royalty-free-music

Sergey Cheremisinov:
http://freemusicarchive.org/music/Sergey_Cheremisinov/The_Signals/Sergey_Cheremisinov_-_The_Signals_-_02_Seven_Lights

Alan Špiljak:
http://freemusicarchive.org/music/Alan_Spiljak/Silverlight/Alan_Spiljak_-_04_-_Empty_days


The client has no interaction.



Documentation Video - 
https://youtu.be/cgy-iLJx3WY
