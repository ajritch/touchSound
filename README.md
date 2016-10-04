# touchSound
touchSound is an iPhone app that responds to capacitative touch sensors hoooked up to an Arduino.

The Arduino connects to a board with six capacitative touch sensors (I used 10 megaohm resistors with the current setup). The Arduino connects directly to the server using the johnny-five Node module, which communicates with the iPhone using socket.io.
