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

    //TODO: Count sets in play.
    //TODO: Add a sensible extension to some data structure.
    //TODO: Animations and delays.

    //MARK: - Properties
    /***************************************************************/
    
    private let cardSpacingColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    private let symbolSize: CGFloat = 20
    
    private var game = GameOfSet()
    private var grid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3))
    private var cards: [SetCardView] = []
    private var playArea = CGRect.zero
    private var cardsLastCount = 0
    private var outOfPlayLastCount = 0
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var remainingCardsLabel: UILabel!
    
    @IBOutlet private weak var actionButtonLabel: UIButton!
    @IBAction private func actionButton(_ sender: UIButton) {
        game.action()
        updateViewFromModel()
    }
    
    @IBAction private func newGameButton(_ sender: UIButton) {
        newGame()
        updateViewFromModel()
    }

    
    //MARK: - Methods
    /***************************************************************/
    
    override func viewDidLoad() {
        actionButtonLabel.isEnabled = false
        actionButtonLabel.setTitle("", for: .normal)
        remainingCardsLabel.isHidden = true
    }
    
    private func newGame() {
        actionButtonLabel.isEnabled = true
        actionButtonLabel.isHidden = false
        remainingCardsLabel.isHidden = false
        
        cards = []
        cardsLastCount = 0
        game = GameOfSet()
        game.newGame()
        
        view.subviews.filter{ $0 is SetCardView }.forEach({ $0.removeFromSuperview() })
        if let viewArea = self.view.subviews.last {
            grid.frame = viewArea.frame
            grid.layout = .dimensions(rowCount: 4, columnCount: 3)
        }
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        getCards()
        updateActionButtonLabel()
        updateTopLabels()
        feedback()
    }
    
    private func getCards() {
        for index in game.cardsInPlay.indices {
            let card = game.cardsInPlay[index]
            if let frame = grid[index] {
                let cardView = SetCardView(card: card, frame: frame)
                cardView.backgroundColor = cardSpacingColor
                cards.append(cardView)
            }
            self.view.addSubview(cards[index])
        }
    }
    
    private func updateActionButtonLabel() {
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
                actionButtonLabel.setTitle("Add 3", for: .normal)
            }
        }
    }
    
    private func updateTopLabels() {
        remainingCardsLabel.text = "Cards Remaining: \(game.cards.count)"
        if game.testMode {
            scoreLabel.text = "TEST MODE"
        } else {
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    private func feedback() {
//        for button in cardButtonsLabels {
//            button.layer.borderWidth = 0
//        }
        for _ in game.indexOfSelected {
//            cardButtonsLabels[index].layer.borderWidth = 3.0
            if let set = game.isASet {
                if set {
                    playSound("ding", dot: "wav")
                } else {
                    playSound("error", dot: "wav")
                }
            } else {
                playSound("beep", dot: "wav")
            }
//            cardButtonsLabels[index].layer.borderColor = highlightColor
        }
        if game.cards.count != cardsLastCount || game.indexOfOutOfPlay.count != outOfPlayLastCount {
            cardsLastCount = game.cards.count
            outOfPlayLastCount = game.indexOfOutOfPlay.count
            if cardsLastCount == 69 {
                playSound("cardShuffle", dot: "wav")
            } else {
                playSound("cardSlide6", dot: "wav")
            }
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

