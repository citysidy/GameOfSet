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

    //TODO: Card size shouldn't change if there are no 3 (or 2) pip cards
    //TODO: Count sets in play.
    //TODO: Add a sensible extension to some data structure.
    //TODO: Animations and delays.

    //MARK: - Properties
    /***************************************************************/
    
    var game = GameOfSet()
    
    let cardBackgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let symbolColors = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
    let symbolShapes = ["▲", "●", "■"]
    let symbolSize: CGFloat = 20
    
    var cardsLastCount = 0
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingCardsLabel: UILabel!
    
    @IBOutlet var cardButtonsLabels: [UIButton]!
    @IBAction func cardButtons(_ sender: UIButton) {
        if let selectedIndex = cardButtonsLabels.firstIndex(of: sender) {
            game.cardSelected(selectedIndex)
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var actionButtonLabel: UIButton!
    @IBAction func actionButton(_ sender: UIButton) {
        game.action()
        updateViewFromModel()
    }
    
    @IBAction func newGameButton(_ sender: UIButton) {
        newGame()
    }

    
    //MARK: - Methods
    /***************************************************************/
    
    override func viewDidLoad() {
        for button in cardButtonsLabels {
            button.layer.cornerRadius = 5.0
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.isEnabled = false
        }
        actionButtonLabel.isEnabled = false
        actionButtonLabel.isHidden = true
        remainingCardsLabel.isHidden = true
    }
    
    func newGame() {
        for index in cardButtonsLabels.indices {
            hideCardButton(at: index)
        }
        actionButtonLabel.isEnabled = true
        actionButtonLabel.isHidden = false
        remainingCardsLabel.isHidden = false
        cardsLastCount = 0
        game = GameOfSet()
        game.newGame()
        updateViewFromModel()
        playSound("cardShuffle", dot: "wav")
    }
    
    func updateViewFromModel() {
        for index in game.cardsInPlay.indices {
            cardButtonsLabels[index].isEnabled = true
            cardButtonsLabels[index].backgroundColor = cardBackgroundColor
            cardButtonsLabels[index].setAttributedTitle(getCardTitle(of: game.cardsInPlay[index]), for: .normal)
        }
        for index in game.indexOfOutOfPlay {
            hideCardButton(at: index)
        }
        updateActionButtonLabel()
        updateTopLabels()
        feedback()
    }
    
    func hideCardButton(at index: Int) {
        cardButtonsLabels[index].isEnabled = false
        cardButtonsLabels[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        cardButtonsLabels[index].setAttributedTitle(nil, for: .normal)
    }
    
    func updateActionButtonLabel() {
        actionButtonLabel.isEnabled = true
        if game.isASet != nil {
            if game.isASet! {
                if game.cards.count > 0 {
                    actionButtonLabel.setTitle("Replace Set", for: .normal)
                } else {
                    actionButtonLabel.setTitle("Clear Set", for: .normal)
                }
            } else {
                actionButtonLabel.setTitle("Clear", for: .normal)
            }
        } else {
            if game.cards.count == 0 {
                actionButtonLabel.setTitle("No Cards Left", for: .normal)
                actionButtonLabel.isEnabled = false
            } else if game.cardsInPlay.count == 24 {
                actionButtonLabel.setTitle("No Room", for: .normal)
                actionButtonLabel.isEnabled = false
            } else if game.cards.count > 0 {
                actionButtonLabel.setTitle("Add 3 Cards", for: .normal)
            }
        }
    }
    
    func updateTopLabels() {
        remainingCardsLabel.text = "Cards Remaining: \(game.cards.count)"
        if game.testMode {
            scoreLabel.text = "TEST MODE"
        } else {
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    func getCardTitle(of card: SetCard) -> NSAttributedString {
        var attributes: [NSAttributedString.Key : Any] = [:]
        var color = symbolColors[card.color.rawValue]
        var shape = symbolShapes[card.shape.rawValue]
        switch card.fill.rawValue {
        case 0:
            attributes[.strokeWidth] = 10
        case 1:
            color = color.withAlphaComponent(0.40)
            fallthrough
        default:
            attributes[.foregroundColor] = color
        }
        attributes[.strokeColor] = color
        attributes[.font] = UIFont.systemFont(ofSize: symbolSize)
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
    
    func feedback() {
        for button in cardButtonsLabels {
            button.layer.borderWidth = 0
        }
        for index in game.indexOfSelected {
            cardButtonsLabels[index].layer.borderWidth = 3.0
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
            cardButtonsLabels[index].layer.borderColor = highlightColor
        }
        if game.cards.count != cardsLastCount {
            playSound("cardSlide6", dot: "wav")
            cardsLastCount = game.cards.count
        }
        hapticFeedback(called: "peek")
    }
    
    
    //MARK: - Haptic
    /***************************************************************/
    
    private func hapticFeedback(called name: String) {
        let haptics = ["peek" : 1519, "pop" : 1520, "cancelled" : 1521, "tryAgain" : 1102, "failed" : 1107, "vibrate" : 4095]
        if let vibrationID = haptics[name] {
            AudioServicesPlaySystemSound(SystemSoundID(vibrationID))
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
        game.testMode = !game.testMode
        updateViewFromModel()
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

