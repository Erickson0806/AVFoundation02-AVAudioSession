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
    weak var delegate: PlayerManageDelegate?
  
    
    
    override init() {
        super.init()
        let guitarPlayer = playerForFile("guitar")
        let bassPlayer = playerForFile("bass")
        let drumsPlayer = playerForFile("drums")
        players = [guitarPlayer,bassPlayer,drumsPlayer]
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleInterruption:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleRouteChange:", name: AVAudioSessionInterruptionNotification, object: AVAudioSession.sharedInstance())

    }
    
    //来电话等打断操作
    func handleInterruption(notification: NSNotification) {
        if let info = notification.userInfo{
            let type = info[AVAudioSessionInterruptionTypeKey] as!AVAudioSessionInterruptionType
            
            if type == .Began {
                stop()
                delegate?.playbackStopped()
            }else {
                let options = info[AVAudioSessionInterruptionOptionKey] as! AVAudioSessionInterruptionOptions
                if options == .ShouldResume {
                    play()
                    delegate?.playbackBegan()
                }
            }
        }
    }
    //拔出耳机等线路改变等操作
    func handleRouteChange(notification: NSNotification) {
        if let info = notification.userInfo {
            let reason = info[AVAudioSessionRouteChangeNotification] as! AVAudioSessionRouteChangeReason
            if reason == .OldDeviceUnavailable {
                let previousRoute = info[AVAudioSessionRouteChangePreviousRouteKey] as! AVAudioSessionRouteDescription
                let previousOutput = previousRoute.outputs.first!
                
                if previousOutput.portType == AVAudioSessionPortHeadphones {
                    stop()
                    delegate?.playbackStopped()
                }
            }
        }
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
