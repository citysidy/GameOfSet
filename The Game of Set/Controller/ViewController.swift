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

    //TODO: New Game method testing and button.
    //TODO: Card size shouldn't change if there are no 3 (or 2) pip cards
    //TODO: Count sets in play.
    //TODO: Refactor and comment.
    //TODO: When any card is chosen and there are already 3 non-matching Set cards selected, deselect those 3 non-matching cards and then select the chosen card.
    //TODO: Add a sensible extension to some data structure.
    //TODO: LaunchScreen.
    //TODO: Animations and delays.
    //TODO: Better audio feedback for successful set.
    #warning ("TODO: Game Over Recognition")
    
    //MARK: - Properties
    /***************************************************************/
    
    var game = GameOfSet()
    
    let cardBackgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    let symbolColors = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
    let symbolShapes = ["▲", "●", "■"]
    let symbolSize: CGFloat = 20
    
    lazy var gameEnd = game.cardsInPlay.count - game.indexOfOutOfPlay.count < 12
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var remainingCardsLabel: UILabel!
    
    @IBOutlet var cardButtonsLabels: [UIButton]!
    @IBAction func cardButtons(_ sender: UIButton) {
        if let selectedIndex = cardButtonsLabels.firstIndex(of: sender) {
            game.cardSelected(selectedIndex)
            hapticFeedback(called: "peek")
        }
        updateViewFromModel()
    }
    
    @IBOutlet weak var actionButtonLabel: UIButton!
    @IBAction func actionButton(_ sender: UIButton) {
        defer {updateViewFromModel()}
        if game.cardsInPlay.count == 0 || gameEnd {
            newGame()
        } else {
            game.action()
            playSound("cardSlide6", dot: "wav")
        }
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    override func viewDidLoad() {
        for button in cardButtonsLabels {
            button.layer.cornerRadius = 5.0
            button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            button.isEnabled = false
        }
        remainingCardsLabel.isHidden = true
    }
    
    func newGame() {
        game = GameOfSet()
        game.newGame()
        game.action(deal: 12)
        remainingCardsLabel.isHidden = false
        playSound("cardShuffle", dot: "wav")
        updateViewFromModel()
    }
    
    func updateViewFromModel() {
        for index in game.cardsInPlay.indices {
            cardButtonsLabels[index].isEnabled = true
            cardButtonsLabels[index].backgroundColor = cardBackgroundColor
            cardButtonsLabels[index].setAttributedTitle(getCardTitle(of: game.cardsInPlay[index]), for: .normal)
        }
        for item in game.indexOfOutOfPlay {
            cardButtonsLabels[item].isEnabled = false
            cardButtonsLabels[item].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            cardButtonsLabels[item].setAttributedTitle(nil, for: .normal)
        }
        updateTopLabels()
        updateDealButtonLabel()
        feedback()
    }
    
    func updateDealButtonLabel() {
        print("Cards In Play: \(game.cardsInPlay.count) - Cards Out Of Play: \(game.indexOfOutOfPlay.count)")
        actionButtonLabel.isEnabled = true
        if game.cardsInPlay.count == 24 && game.isASet == nil {
            actionButtonLabel.setTitle("No Room", for: .normal)
            actionButtonLabel.isEnabled = false
        } else if game.isASet != nil {
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
            if game.cards.count > 0 {
                actionButtonLabel.setTitle("Deal 3 More", for: .normal)
            } else if gameEnd {
                actionButtonLabel.setTitle("Start New Game", for: .normal)
            } else {
                actionButtonLabel.setTitle("No Cards Left", for: .normal)
                actionButtonLabel.isEnabled = false
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

