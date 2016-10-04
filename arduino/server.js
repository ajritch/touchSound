var express = require('express');
var path = require('path');
var bodyParser = require('body-parser');
var five = require("johnny-five");

var app = express();

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, './client')));
app.use(express.static(path.join(__dirname, './bower_components')));

//database config
// require('./server/config/mongoose.js');

//module config and routing
require('./server/config/routes.js')(app);

var server = app.listen(7000, function() {
	console.log('listening on port 7000');
});

//SOCKETS!!!!!!
var io = require('socket.io').listen(server);

io.sockets.on('connection', function(socket) {
	console.log(socket.id);
	socket.emit('new_connection');

	var board = new five.Board();
	board.on("ready", function() {
		console.log('woooo')

		var threshold = 60
		var sensor0 = new five.Sensor({pin: "A0", threshold: threshold});
		var sensor1 = new five.Sensor({pin: "A1", threshold: threshold});
		var sensor2 = new five.Sensor({pin: "A2", threshold: threshold});
		var sensor3 = new five.Sensor({pin: "A3", threshold: threshold});
		var sensor4 = new five.Sensor({pin: "A4", threshold: threshold});
		var sensor5 = new five.Sensor({pin: "A5", threshold: threshold});

		var first_set = true;

		//turn on sensors
		sensor0.on("change", function() {
			if (!first_set) {
				console.log("touched 0");
				console.log(this.value);
				socket.emit("sensor_touched", 0);
			}
		});

		sensor1.on("change", function() {
			if (!first_set) {
				console.log("touched 1");
				console.log(this.value);
				socket.emit("sensor_touched", 1);
			}
		});

		sensor2.on("change", function() {
			if (!first_set) {
				console.log("touched 2");
				console.log(this.value);
				socket.emit("sensor_touched", 2);
			}
		});

		sensor3.on("change", function() {
			if (!first_set) {
				console.log("touched 3");
				console.log(this.value);
				socket.emit("sensor_touched", 3);
			}
		});

		sensor4.on("change", function() {
			if (!first_set) {
				console.log("touched 4");
				console.log(this.value);
				socket.emit("sensor_touched", 4);
			}
		});

		sensor5.on("change", function() {
			if (!first_set) {
				console.log("touched 5");
				console.log(this.value);
				socket.emit("sensor_touched", 5);
			}
			first_set = false;
		});



		// var sensor0 = new five.Sensor("A0");
		// var sensor1 = new five.Sensor("A1");
		// var sensor2 = new five.Sensor("A2");
		// var sensor3 = new five.Sensor("A3");
		// var sensor4 = new five.Sensor("A4");
		// var sensor5 = new five.Sensor("A5");

		// //turn on sensors
		// sensor0.on("change", function() {
		// 	var value = this.scaleTo(0,10000);
		// 	if (value < 9000) {
		// 		console.log("touched 0!");
		// 		socket.emit("sensor_touched", 0);
		// 	}
		// 	// console.log(value);
		// });

		// sensor1.on("change", function() {
		// 	var value = this.scaleTo(0, 10000);
		// 	if (value < 9000) {
		// 		console.log("touched 1!");
		// 		socket.emit("sensor_touched", 1);
		// 	}
		// 	// console.log(value);
		// });

		// sensor2.on("change", function() {
		// 	var value = this.scaleTo(0,10000);
		// 	if (value < 9000) {
		// 		console.log("touched 2!");
		// 		socket.emit("sensor_touched", 2);
		// 	}
		// 	// console.log(value);
		// });

		// sensor3.on("change", function() {
		// 	var value = this.scaleTo(0, 10000);
		// 	if (value < 9000) {
		// 		console.log("touched 3!");
		// 		socket.emit("sensor_touched", 3);
		// 	}
		// 	// console.log(value);
		// });

		// sensor4.on("change", function() {
		// 	var value = this.scaleTo(0,10000);
		// 	if (value < 9000) {
		// 		console.log("touched 4!");
		// 		socket.emit("sensor_touched", 4);
		// 	}
		// 	// console.log(value);
		// });

		// sensor5.on("change", function() {
		// 	var value = this.scaleTo(0, 10000);
		// 	if (value < 9000) {
		// 		console.log("touched 5!");
		// 		socket.emit("sensor_touched", 5);
		// 	}
		// 	// console.log(value);
		// });

	});
});

//MAKE SURE SENSORS ALL WORK WHEN NO CONNECTION!!
// var board = new five.Board();
// board.on("ready", function() {
// 	console.log('woooo')
// 	var threshold = 32
// 	var sensor0 = new five.Sensor({pin: "A0", threshold: threshold});
// 	var sensor1 = new five.Sensor({pin: "A1", threshold: threshold});
// 	var sensor2 = new five.Sensor({pin: "A2", threshold: threshold});
// 	var sensor3 = new five.Sensor({pin: "A3", threshold: threshold});
// 	var sensor4 = new five.Sensor({pin: "A4", threshold: threshold});
// 	var sensor5 = new five.Sensor({pin: "A5", threshold: threshold});

// 	//turn on sensors
// 	sensor0.on("change", function() {
// 		console.log("touched 0")
// 		console.log(this.value)
// 	});

// 	sensor1.on("change", function() {
// 		var value = this.scaleTo(0, 10000);
// 		console.log("touched 1");
// 		console.log(this.value)
// 	});

// 	sensor2.on("change", function() {
// 		console.log("touched 2")
// 	});

// 	sensor3.on("change", function() {
// 		console.log("touched 3")
// 	});

// 	sensor4.on("change", function() {
// 		console.log("touched 4")
// 	});

// 	sensor5.on("change", function() {
// 		console.log("touched 5")
// 	});

// });

