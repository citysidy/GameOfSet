//
//  ViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    //MARK: - Properties
    /***************************************************************/
    
    var game = GameOfSet()
    let colors = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
    let shapes = ["▲", "●", "■"]
    let size: CGFloat = 20
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingCardsLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func cardButtonSelected(_ sender: UIButton) {
        if let selectedIndex = cardButtons.firstIndex(of: sender) {
            game.cardSelected(selectedIndex)
            hapticFeedback(called: "peek")
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var dealButtonLabel: UIButton!
    @IBAction func dealButton(_ sender: UIButton) {
        guard game.cardsInPlay.count < cardButtons.count - 2  else {
            return
        }
        if game.cardsInPlay.count == 0 || game.cardsRemaining == 0 {
            playSound("cardShuffle", dot: "wav")
            newGame()
        } else {
            playSound("cardSlide6", dot: "wav")
            game.deal(3)
        }
        updateViewFromModel()
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    override func viewDidLoad() {
        for button in cardButtons {
            button.layer.cornerRadius = 5.0
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.isEnabled = false
            //button.isHidden = true
        }
        remainingCardsLabel.isHidden = true
    }
    
    func newGame() {
        game = GameOfSet()
        game.deal(12)
        dealButtonLabel.setTitle("Deal 3 Cards", for: .normal)
        remainingCardsLabel.isHidden = false
    }
    
    func updateViewFromModel() {
        if game.cardsRemaining == 0 {
            dealButtonLabel.setTitle("Start New Game", for: .normal)
        }
        for button in cardButtons {
            button.layer.borderWidth = 0
        }
        for index in game.cardsInPlay.indices {
            cardButtons[index].isEnabled = true
            cardButtons[index].isHidden = false
            cardButtons[index].setAttributedTitle(getCardTitle(of: game.cardsInPlay[index]), for: .normal)
        }
        for index in game.indexOfSelected {
            cardButtons[index].layer.borderWidth = 3.0
            var highlightColor = UIColor.blue.cgColor
            if let set = game.isASet {
                if set {
                    highlightColor = UIColor.green.cgColor
                    playSound("ding", dot: "wav")
                } else {
                    highlightColor = UIColor.red.cgColor
                    playSound("error", dot: "wav")
                }
            } else {
                playSound("beep", dot: "wav")
            }
            cardButtons[index].layer.borderColor = highlightColor
        }
        scoreLabel.text = "Score: \(game.score)"
        remainingCardsLabel.text = "Cards Remaining: \(game.cardsRemaining)"
    }
    
    func getCardTitle(of card: SetCard) -> NSAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [:]
        var color = colors[card.color.rawValue]
        var shape = shapes[card.shape.rawValue]
        switch card.fill.rawValue {
            case 0:
                attributes[.strokeWidth] = 6
            case 1:
                color = color.withAlphaComponent(0.40)
                fallthrough
            default:
                attributes[.foregroundColor] = color
        }
        attributes[.strokeColor] = color
        attributes[.font] = UIFont.systemFont(ofSize: size)
        switch card.pips.rawValue {
            case 0:
                break
            case 1:
                shape = shape + "\n" + shape
            default:
                shape = shape + "\n" + shape + "\n" + shape
        }
        return NSAttributedString(string: shape, attributes: attributes)
    }
    
    
    //MARK: - Haptic
    /***************************************************************/
    
    private func hapticFeedback(called name: String) {
        let haptics = ["peek" : 1519, "pop" : 1520, "cancelled" : 1521, "tryAgain" : 1102, "failed" : 1107, "vibrate" : 4095]
        if let vibrationID = haptics[name] {
            AudioServicesPlaySystemSound(SystemSoundID(vibrationID))
        } else {
            print("\n=======================\nError: hapticFeedback - name not found\n=======================\n")
        }
    }
    
    
    //MARK: - Audio
    /***************************************************************/
    
    private func playSound(_ name: String, dot ext: String) {
        let fileURL = Bundle.main.url(forResource: name, withExtension: ext)!
        var mySound: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(fileURL as CFURL, &mySound)
        AudioServicesPlaySystemSound(mySound)
    }
    
    
    //MARK: - Shake
    /***************************************************************/
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        newGame()
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

