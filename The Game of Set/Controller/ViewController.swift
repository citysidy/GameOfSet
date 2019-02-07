//
//  ViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    //MARK: - Properties
    /***************************************************************/
    
    var deck = GameOfSet()
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    
    //MARK: - Methods
    /***************************************************************/
//    override func viewDidLoad() {
//        <#code#>
//    }
    
    //MARK: - Haptic
    /***************************************************************/
    
//    private func hapticFeedback(called name: String) {
//        let haptics = ["peek" : 1519, "pop" : 1520, "cancelled" : 1521, "tryAgain" : 1102, "failed" : 1107, "vibrate" : 4095]
//        if let vibrationID = haptics[name] {
//            AudioServicesPlaySystemSound(SystemSoundID(vibrationID))
//            if self.debug {print("Haptic played: \(vibrationID) - \(name)")}
//        } else {
//            print("\n=======================\nError: hapticFeedback - name not found\n=======================\n")
//        }
//    }
    
    //MARK: - Audio
    /***************************************************************/
    
//    private func playSound(_ name: String, dot ext: String) {
//        let fileURL = Bundle.main.url(forResource: name, withExtension: ext)!
//        var mySound: SystemSoundID = 0
//        AudioServicesCreateSystemSoundID(fileURL as CFURL, &mySound)
//        AudioServicesPlaySystemSound(mySound)
//        if debug {print("Sound played: \(mySound) - \(name)")}
//    }
    
    //MARK: - Shake
    /***************************************************************/
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    }
    
    
    
}

//MARK: - Extension
/***************************************************************/

extension Int {
    //Random generator from 0 to < Int
    var rando: Int {
        if self > 0 {
            return +Int.random(in: 0 ..< +self)
        } else
            if self < 0 {
                return -Int.random(in: 0 ..< -self)
            } else {
                return 0
        }
    }
}

extension Collection {
    //If the collection only contains one element, return that element, otherwise nil
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

