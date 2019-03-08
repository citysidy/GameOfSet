//
//  ViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    //TODO: Count sets in play.
    //TODO: Animations and delays.

    //MARK: - Properties
    /***************************************************************/
    
    private let selectedColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    private let setColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    private let noSetColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
    
    private var game = GameOfSet()
    private var grid = Grid(layout: .dimensions(rowCount: 1, columnCount: 1))
    private var cardsOnBoard: [SetCardView] = []
    private var remainingCount = 0
    private var selectedCount = 0
    private var selectedTag = 0 {
        didSet {
            game.cardSelected(selectedTag)
            updateViewFromModel()
        }
    }
    
    
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
        updateViewFromModel()
    }
    
    @IBAction func selectCard(_ sender: UITapGestureRecognizer) {
        switch sender.state {
        case .ended:
            if game.cardsInPlay.count == 0 {
                newGame()
            }
            updateViewFromModel()
        default:
            break
        }
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func viewDidLoad() {
        actionButtonLabel.isEnabled = false
        actionButtonLabel.setTitle("", for: .normal)
        remainingCardsLabel.isHidden = true
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
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
        removeExistingCardsFromBoard()
        calculateGridLayout()
        calculateGridFrame()
        drawCardsOnBoard()
        updateActionButtonLabel()
        updateTopLabels()
        audioAndHapticFeedback()
    }
    
    private func removeExistingCardsFromBoard() {
        cardsOnBoard = []
        view.subviews.filter{ $0 is SetCardView }.forEach({ $0.removeFromSuperview() })
    }
    
    private func calculateGridLayout() {
        let count = game.cardsInPlay.count
        if count == 0 {return}
        let longSide = count.isqrt
        let shortSide = (count + longSide - 1) / longSide
        switch UIDevice.current.orientation {
        case .portrait:
            grid.layout = .dimensions(rowCount: shortSide, columnCount: longSide)
        default:
            grid.layout = .dimensions(rowCount: longSide, columnCount: shortSide)
        }
    }
    
    private func calculateGridFrame() {
        if let viewArea = view.viewWithTag(-1) {
            grid.frame = viewArea.frame
        }
    }
    
    private func drawCardsOnBoard() {
        for index in game.cardsInPlay.indices {
            let card = game.cardsInPlay[index]
            if let frame = grid[index] {
                let cardView = SetCardView(card: card, frame: frame)
                cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardsOnBoard.append(cardView)
            }
            if game.indexOfSelected.contains(index) {
                var color = selectedColor
                if let set = game.isASet {
                    if set {
                        color = setColor
                    } else {
                        color = noSetColor
                    }
                }
                cardsOnBoard[index].highlightColor = color
            }
            view.addSubview(cardsOnBoard[index])
            cardsOnBoard[index].tag = index + 1
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
            gestureRecognizer.delegate = self
            cardsOnBoard[index].addGestureRecognizer(gestureRecognizer)
        }
    }
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        let view = gestureRecognizer.view
        let loc = gestureRecognizer.location(in: view)
        if let cardView = view {
            let sub = cardView.hitTest(loc, with: nil)
            let subTag = sub!.tag
            let symTag = sub!.superview!.tag
            selectedTag = subTag + symTag - 1
        }
    }
    
    private func updateActionButtonLabel() {
        actionButtonLabel.isEnabled = true
        if let set = game.isASet {
            if set {
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
    
    private func audioAndHapticFeedback() {
        if game.cards.count != remainingCount {
            remainingCount = game.cards.count
            if game.cards.count == 69 {
                playSound("cardShuffle", dot: "wav")
            } else {
                playSound("cardSlide6", dot: "wav")
            }
        }
        if let set = game.isASet {
            if set {
                playSound("ding", dot: "wav")
            } else {
                playSound("error", dot: "wav")
            }
        } else if game.indexOfSelected.count > selectedCount {
            playSound("beep", dot: "wav")
        }
        selectedCount = game.indexOfSelected.count
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
    
    var isqrt: Int {
        if self > 0 {
            return Int(Double(self).squareRoot())
        } else
        {return 1}
    }
    
    
}

