//
//  PlayerManager.swift
//  AVAudioSessionSwift
//
//  Created by Erickson on 16/1/6.
//  Copyright © 2016年 erickson. All rights reserved.
//

import UIKit
import AVFoundation
class PlayerManager: NSObject {

    
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
}
