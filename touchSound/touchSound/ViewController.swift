//
//  ViewController.swift
//  touchSound
//
//  Created by Annie Ritch on 9/28/16.
//  Copyright © 2016 Andrea Ritch. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation
import SocketIO

class ViewController: UIViewController {
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    //define socket
    let socket = SocketIOClient(socketURL: NSURL(string: "http://Annie-MacBook.local:7000")!)
    
    //setup all the background URLS
    var backgroundAudioURLS = [
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/song1", ofType: "wav")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/song2", ofType: "wav")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/song3", ofType: "wav")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/song4", ofType: "wav")!),
        NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/song5", ofType: "wav")!)]
    var currSong = 1 //currently playing song
    
    var backgroundAudioPlayer = AVAudioPlayer()
    
    //set up all the urls
    //sensor 0 has no player -- it changes songs
    var sensor1URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/laugh", ofType: "wav")!)
    var sensor1Player = AVAudioPlayer()
    var sensor2URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/tada", ofType: "wav")!)
    var sensor2Player = AVAudioPlayer()
    //SENSOR 3 SPECIAL :D
    var rickRollURL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/RickRoll", ofType: "wav")!)
    var rickRollPlayer = AVAudioPlayer()
    var sensor4URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/explosion", ofType: "wav")!)
    var sensor4Player = AVAudioPlayer()
    var sensor5URL = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Audio/game", ofType: "wav")!)
    var sensor5Player = AVAudioPlayer()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        imageView.image = UIImage(named: "P1140252")
        
        playButton.setTitle("Pause", forState: UIControlState.Normal)
        
        //load the Jason goat file image
        
        
        do {
            backgroundAudioPlayer = try AVAudioPlayer(contentsOfURL: backgroundAudioURLS[0])
            currSong = 1
            sensor1Player = try AVAudioPlayer(contentsOfURL: sensor1URL)
            sensor2Player = try AVAudioPlayer(contentsOfURL: sensor2URL)
            rickRollPlayer = try AVAudioPlayer(contentsOfURL: rickRollURL) //SPECIAL
            sensor4Player = try AVAudioPlayer(contentsOfURL: sensor4URL)
            sensor5Player = try AVAudioPlayer(contentsOfURL: sensor5URL)
            backgroundAudioPlayer.numberOfLoops = -1
//            backgroundAudioPlayer.play()
        } catch {
            print("Error establishing audio: \(error)")
        }
        self.addHandlers()
        self.socket.connect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func playAudioButtonPressed(sender: UIButton) {
        if backgroundAudioPlayer.playing {
            backgroundAudioPlayer.stop()
            playButton.setTitle("Play", forState: UIControlState.Normal)
        } else {
            backgroundAudioPlayer.play()
            playButton.setTitle("Pause", forState: UIControlState.Normal)
        }
    }
    
    
    //SOCKET HANDLERS
    func addHandlers() {
        self.socket.on("new_connection") {
            [weak self] data, ack in
            print("hello there")
            self!.backgroundAudioPlayer.play()
        }
        
        self.socket.on("sensor_touched") {
            [weak self] data, ack in
//            print("sensor \(data["sensor"])")
//            print("touched")
//            print(data[0])
            let sensor = data[0] as! Int
            print("touched sensor \(sensor)")
            
            switch(sensor) {
                case 0:
                    print("zero")
                    self!.playSensor0();
                case 1:
                    print("one")
                    self!.playSensor1()
                case 2:
                    print("two")
                    self!.playSensor2()
                case 3:
                    print("Rick Rolled!")
                    self!.playSensor3()
                case 4:
                    print("four")
                    self!.playSensor4()
                case 5:
                    print("five")
                    self!.playSensor5()
                default:
                    print("other")
            }
        }
    }
    
    /***** playSensor FUNCTIONS *****/
    
    //variables to keep track of down vs up touches
    var down0 = true
    var down1 = true
    var down2 = true
    var down3 = true
    var down4 = true
    var down5 = true
    
    //CHANGE BACKGROUND SONGS
    func playSensor0() {
        //only change if RickRoll isn't playing!!!
        if down0 {
            if !rickRollPlayer.playing {
                currSong += 1
                if currSong > 5 {
                    currSong = 1
                }
                do {
                    backgroundAudioPlayer = try AVAudioPlayer(contentsOfURL: backgroundAudioURLS[currSong - 1])
                    backgroundAudioPlayer.numberOfLoops = -1
                    backgroundAudioPlayer.play()
                } catch {
                    print("Error establishing background audio: \(error)")
                }
            }
        }
        down0 = !down0
    }
    
    func playSensor1() {
        if down1 {
            if sensor1Player.playing {
                sensor1Player.stop()
            } else {
                sensor1Player.play()
            }
        }
        down1 = !down1
    }
    
    func playSensor2() {
        if down2 {
            if sensor2Player.playing {
                sensor2Player.stop()
            } else {
                sensor2Player.play()
            }
        }
        down2 = !down2
    }
    
    //USE RICK ASTLEY and change photo
    func playSensor3() {
        if down3 {
            if rickRollPlayer.playing {
                imageView.image = UIImage(named: "P1140252")
                rickRollPlayer.stop()
                backgroundAudioPlayer.play()
            } else {
                imageView.image = UIImage(named: "P1120021")
                rickRollPlayer.play()
                backgroundAudioPlayer.stop()
            }
        }
       down3 = !down3
    }
    
    func playSensor4() {
        if down4 {
            if sensor4Player.playing {
                sensor4Player.stop()
            } else {
                sensor4Player.play()
            }
        }
        down4 = !down4
    }
    
    func playSensor5() {
        if down5 {
            if sensor5Player.playing {
                sensor5Player.stop()
            } else {
                sensor5Player.play()
            }
        }
        down5 = !down5
    }
    

    
}

