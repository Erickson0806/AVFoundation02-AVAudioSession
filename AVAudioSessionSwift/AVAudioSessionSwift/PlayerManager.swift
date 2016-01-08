//
//  PlayerManager.swift
//  AVAudioSessionSwift
//
//  Created by Erickson on 16/1/6.
//  Copyright © 2016年 erickson. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerManageDelegate :class {
    func playbackStopped()
    func playbackBegan()
}




class PlayerManager: NSObject {

    var playing = false
    var players: [AVAudioPlayer]!
    
    
    
    override init() {
        super.init()
        let guitarPlayer = playerForFile("guitar")
        let bassPlayer = playerForFile("bass")
        let drumsPlayer = playerForFile("drums")
        players = [guitarPlayer,bassPlayer,drumsPlayer]
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRouteChange:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())

        
    }
    
    
    func handleInterruption(notification: NSNotification) {
        
    }
    
    func handleRouteChange(notification: NSNotification) {
        
    }

    func playerForFile(name:String) -> AVAudioPlayer {
        
        let fileURL = NSBundle.mainBundle().URLForResource(name, withExtension: "caf")!
        
        do {
            let player = try AVAudioPlayer(contentsOfURL: fileURL)
            player.numberOfLoops = -1;
            player.enableRate = true
            player.prepareToPlay()
            return player
        } catch let error as NSError {
            print(error)
            fatalError()
        }
    }
    
    func play() {
        if !playing {
            let delayTime = players.first!.deviceCurrentTime + 0.01
            for player in players {
                player.playAtTime(delayTime)
            }
            playing = true
        }
    }
    func stop (){
        if playing {
            for player in players {
                player.stop()
                player.currentTime = 0.0
            }
            playing = false
        }
    }
    func adjuctRate(rate:Double) {
        for player in players {
            player.rate = Float(rate)
        }
    }
    func adjustPan(pan:Double ,forPlayerAtIndex index:Int) {
        if index >= 0 && index < players.count {
            players[index].pan = Float(pan)
        }
    }
    
    func adjustVolume(volume:Double ,forPlayerAtIndex index:Int) {
        if index >= 0 && index < players.count {
            players[index].volume = Float(volume)
        }
    }
    
}




extension PlayerManager:AVAudioPlayerDelegate {
    
}
