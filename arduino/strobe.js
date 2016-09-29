var five = require("johnny-five");
var board = new five.Board();

// board.on("ready", function() {
// 	//create an LED on pin 13
// 	var led = new five.Led(13);

// 	led.strobe();
// });

board.on("ready", function() {
	console.log('woooo')
	var sensor = new five.Sensor("A0");

	sensor.on("change", function() {
		var value = this.scaleTo(0,100);
		if (value < 99) {
			console.log("touched!")
		}
		console.log(this.scaleTo(0,100));
		// console.log('sensor');
	});
})