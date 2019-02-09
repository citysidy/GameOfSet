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
    let colors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)]
    let shapes = ["▲", "●", "■"]
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func cardTouched(_ sender: UIButton) {
        updateViewFromModel()
    }
    @IBAction func deal3Button(_ sender: UIButton) {
    }
    
    //MARK: - Methods
    /***************************************************************/
    override func viewDidLoad() {
        deck.deal(12)
    }
    
    func updateViewFromModel() {
        for index in deck.inPlay.indices {
            let title = getCardTitle(of: deck.inPlay[index])
            cardButtons[index].titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cardButtons[index].setAttributedTitle(title, for: .normal)
        }
    }
    
    
    func getCardTitle(of card: SetCard) -> NSAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [:]
        var text: NSAttributedString
        var color = colors[card.color.rawValue]
        var shape = shapes[card.shape.rawValue]
        switch card.fill.rawValue {
            case 0:
                attributes[.strokeWidth] = 4
            case 1:
                color = color.withAlphaComponent(0.50)
                fallthrough
            default:
                attributes[.foregroundColor] = color
        }
        attributes[.strokeColor] = color
        attributes[.font] = UIFont.systemFont(ofSize: 26)
        //attributes[.strokeWidth] = fill
        switch card.pips.rawValue {
            case 0:
                break
            case 1:
                shape = shape + "\n" + shape
            default:
                shape = shape + "\n" + shape + "\n" + shape
        }
        print(shape + "\n")
        text = NSAttributedString(string: shape, attributes: attributes)
        return text
    }
    
    
    
    
    
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
        } else
        
        {return 0}
    }
}

extension Collection {
    //If the collection only contains one element, return that element, otherwise nil
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}

