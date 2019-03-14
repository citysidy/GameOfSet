//
//  ConcentrationViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 3/12/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit
import AVFoundation

class ConcentrationViewController: UIViewController {
    
    
    //MARK: - Properties
    /***************************************************************/
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private var numberOfPairsOfCards: Int {
        if cardButtons == nil {return 8}
        return (self.cardButtons.count + 1) / 2 //Rounding up in the case of odd number of buttons
    }

    private var themeName = ""
    private var emojiChoices = "☀︎☽☁︎☔︎★♠︎♣︎♥︎♦︎♚♛♜♝♞♟⚀⚁⚂⚃⚄⚅☕︎✌︎✒︎✏︎☯︎☮︎"
    private var buttonColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
    private var viewBackground = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private var emoji = [Card:String]() //Create an empty dictionary to map the emojis to their cards
    
    var theme: (String,String,UIColor,UIColor)? {
        didSet {
            themeName = theme?.0 ?? "Default"
            emojiChoices = theme?.1 ?? ""
            buttonColor = theme?.2 ?? buttonColor
            emoji = [:]
            updateViewFromModel()
        }
    }
    private(set) var score = "" {
        didSet {
            updateScoreLabel()
        }
    }


    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBAction func buttonPressed(_ sender: UIButton) {
        if game.over() {newGame(); return} //Use the card buttons to activate a new game
        if let cardNumber = cardButtons.firstIndex(of: sender) { //All buttons assigned to the same IBOutlet
            game.chooseCard(at: cardNumber)
            updateViewFromModel() //After processing update view to match new state of the model
        }
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    override func viewDidLoad() {
        newGame()
    }
    
    private func newGame() {
        self.view.backgroundColor = viewBackground
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
    }
    
    private func emoji(for card: Card) -> String {
        //This function chooses the emoji to put on a card when it is flipped
        if emoji[card] == nil, emojiChoices.count > 0 { //Card has no emoji and there are emoji available
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.rando) //Select random position
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex)) //Attach emoji to card
        }
        return emoji[card] ?? "❓"
    }
    
    private func updateViewFromModel() {
        //TODO - Score
        score = "Score: \(game.score) - Flips: \(game.flips)"
        if cardButtons != nil {
            for index in cardButtons.indices { //Check status of each card from model
                let card = game.deck[index]
                let button = cardButtons[index]
                if card.isFaceUp {
                    button.setTitle(emoji(for: card), for: UIControl.State.normal) //Show the emoji
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                } else { //Facedown cards
                    button.setTitle("", for: UIControl.State.normal)
                    button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) : buttonColor //Hide matched cards
                }
                button.isEnabled = !card.isFaceUp && !card.isMatched //Disable matched or face up + enable not matched and face down
            }
            if game.over() {showAllCards()}
            feedback(game.currentStatus.rawValue)
        }
    }
    
    private func updateScoreLabel() {
        //Called from the counter didSet
        let attrib: [NSAttributedString.Key : Any] = [
            .strokeColor : buttonColor,
            .strokeWidth : 5.0
        ]
        let attribtext = NSAttributedString(string: score, attributes: attrib)
        if scoreLabel != nil {
            scoreLabel.attributedText = attribtext
        }
    }
    
    private func showAllCards() {
        //Called when the game ends
        for index in cardButtons.indices {
            cardButtons[index].setTitle(emoji(for: game.deck[index]), for: UIControl.State.normal)
            cardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            cardButtons[index].isEnabled = true
        }
    }
    
    private func feedback(_ buttonResult: String) {
        //Chooses the audio and haptic feedback based on result of button press
        switch buttonResult {
        case "noMatch":
            hapticFeedback(called: "cancelled")
            playSound("error", dot: "wav")
        case "firstChoice":
            hapticFeedback(called: "peek")
            playSound("metronome", dot: "wav")
        case "gameOver":
            playSound("ding", dot: "wav")
            hapticFeedback(called: "vibrate")
            playSound("party", dot: "wav")
        default: //cardMatch and newGame
            hapticFeedback(called: "tryAgain")
            playSound("ding", dot: "wav")
        }
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
