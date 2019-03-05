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
    //TODO: Animations and delays.

    //MARK: - Properties
    /***************************************************************/
    
    private let cardSpacingColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
    
    private var game = GameOfSet()
    private var grid = Grid(layout: .dimensions(rowCount: 1, columnCount: 1))
    private var cardsOnBoard: [SetCardView] = []
    private var remainingCount = 0
    private var outOfPlayCount = 0
    
    
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

    @IBAction private func settingsButton(_ sender: UIButton) {
        if let viewArea = view.viewWithTag(1) {
            print("\nViewAea:\nWidth:\(viewArea.frame.size.width) - Height:\(viewArea.frame.size.height)\n")
            viewArea.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        }
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
    
        remainingCount = 0
        game = GameOfSet()
        game.newGame()
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        drawCardsOnBoard()
        updateActionButtonLabel()
        updateTopLabels()
        feedback()
    }
    
    private func drawCardsOnBoard() {
        removeExistingCardsFromBoard()
        grid.layout = calculateGridLayout()
        if let viewArea = view.viewWithTag(1) {
            grid.frame = viewArea.frame
            viewArea.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        }
        for index in game.cardsInPlay.indices {
            let card = game.cardsInPlay[index]
            if let frame = grid[index] {
                let cardView = SetCardView(card: card, frame: frame)
                cardView.backgroundColor = cardSpacingColor
                cardsOnBoard.append(cardView)
            }
            view.addSubview(cardsOnBoard[index])
        }
    }
    
    private func removeExistingCardsFromBoard() {
        cardsOnBoard = []
        view.subviews.filter{ $0 is SetCardView }.forEach({ $0.removeFromSuperview() })
    }
    
    private func calculateGridLayout() -> Grid.Layout {
        guard game.cardsInPlay.count > 0 else {return .dimensions(rowCount: 1, columnCount: 1)}
        let count = game.cardsInPlay.count
        let longSide = count.isqrt
        let shortSide = (count + longSide - 1) / longSide
        switch UIDevice.current.orientation {
        case .portrait:
            return .dimensions(rowCount: shortSide, columnCount: longSide)
        default:
            return .dimensions(rowCount: longSide, columnCount: shortSide)
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
            } else {
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
        if game.cards.count != remainingCount || game.indexOfOutOfPlay.count != outOfPlayCount {
            remainingCount = game.cards.count
            outOfPlayCount = game.indexOfOutOfPlay.count
            if game.cards.count == 69 {
                playSound("cardShuffle", dot: "wav")
            } else {
                playSound("cardSlide6", dot: "wav")
            }
        }
        hapticFeedback(called: "peek")
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print("Width:\(view.viewWithTag(1)?.frame.size.width) - Height:\(view.viewWithTag(1)?.frame.size.height)")
        if traitCollection.horizontalSizeClass == .compact {
            // load slim view
            print("Compact")
        } else {
            // load wide view
            print("Wide")
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
    
    var isqrt: Int {
        if self > 0 {
            return Int(Double(self).squareRoot())
        } else
        {return 1}
    }
    
    
}

