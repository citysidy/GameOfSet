//
//  ViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

/*TODO:
Fix scoring so it updates immediately instead of "on next tap"
Hints
Animations for cards
Card shadows
Animated popups for scoring
Settings menu
Help/Instructions
Timer based score modifiers
Light Mode/Dark Mode
Easy play mode (less card properties)
scoreboard
endgame
*/


import UIKit
import AVFoundation

class GameOfSetViewController: UIViewController, UIGestureRecognizerDelegate {

    
    //MARK: - Properties
    /***************************************************************/
    
    private let cardColors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)] //Colors for the card symbols
    
    private let selectionColors = ["select":#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),"set":#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),"noset":#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)] //Colors for the selection borders
    
    private var game = GameOfSet()
    private var grid = Grid(layout: .dimensions(rowCount: 1, columnCount: 1))
    private var cardsInPlay: [SetCardView] = []
    
    //Counter variables to track game state
    private var cardsInPlayCount = 0
    private var cardsOutOfPlayCount = 0
    private var cardsSelectedCount = 0
    
    private var selectedCardIndex = 0 {
        didSet { //Updated by touch events
            game.cardSelected(selectedCardIndex)
            updateViewFromModel()
        }
    }
    
    
    //MARK: - Init IBOutlets Actions
    /***************************************************************/
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var remainingCardsLabel: UILabel!
    
    @IBOutlet private weak var actionButtonLabel: UIButton!
    @IBAction private func actionButton(_ sender: UIButton) {
        game.action()
        updateViewFromModel()
    }
    
    @IBOutlet weak var newGameButtonLabel: UIButton!
    @IBAction private func newGameButton(_ sender: UIButton) {
        newGame()
    }

    @IBOutlet weak var settingsButtonLabel: UIButton!
    @IBAction private func settingsButton(_ sender: UIButton) {
        if game.cardsInPlay.count == 0 {return}
        updateViewFromModel() //Temp action until settings are actually implemented
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func viewDidLoad() {
        configureFonts()
        actionButtonLabel.isEnabled = false
        actionButtonLabel.setTitle("", for: .normal)
        remainingCardsLabel.isHidden = true
        
        //Tap Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(gestureRecognizer:)))
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
        
        //Rotate Gesture
        let rotateGestureRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotate(gestureRecognizer:)))
        self.view.addGestureRecognizer(rotateGestureRecognizer)
        rotateGestureRecognizer.delegate = self
        
        //Swipe Down Gesture
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gestureRecognizer:)))
        swipeGestureRecognizer.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeGestureRecognizer)
        swipeGestureRecognizer.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        //Update the views if the game is started and the main frame size changes
        if view.viewWithTag(-1)!.frame != grid.frame && game.cardsInPlay.count > 0 {
            updateViewFromModel()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //Handle font accessiblity settings
        configureFonts()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //Shaking toggles test mode for testing end-game
        game.testMode = !game.testMode
        updateViewFromModel()
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            if game.cardsInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            let view = gestureRecognizer.view //Being verbose since this part is confusing
            let loc = gestureRecognizer.location(in: view) //Get the location of the tap
            if let cardView = view { //Unwrap the view the tap recognized
                if let sub = cardView.hitTest(loc, with: nil) { //Unwrap the subview at the tap location (not sure what the with: nil parameter is)
                    let subTag = sub.tag //Get the tag of the subview that was tapped
                    if let superView = sub.superview { //Unwrap the superview of the tapped view
                        let superTag = superView.tag //Get the tag of the superview that was tapped
                        if subTag + superTag > 0 { //Sum of subtag and super tag has to be non zero (ie tapped on card)
                            selectedCardIndex = subTag + superTag - 1 //Subtract one to get index of card since tag was index + 1
                        }
                    }
                }
            }
        default: break
        }
    }
    
    @objc private func handleSwipe(gestureRecognizer: UISwipeGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            if game.cardsInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            actionButtonLabel.sendActions(for: .touchUpInside) //Swipe down just duplicates the Action button function
        default: break
        }
    }
    
    @objc private func handleRotate(gestureRecognizer: UIRotationGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            if game.cardsInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            game.shuffleCardsInPlay()
            updateViewFromModel()
        default: break
        }
    }
    
    private func newGame() {
        //Set up game board
        actionButtonLabel.isEnabled = true
        actionButtonLabel.isHidden = false
        remainingCardsLabel.isHidden = false
        
        //Initialize game variables
        cardsInPlayCount = 0
        cardsOutOfPlayCount = 0
        cardsSelectedCount = 0
        game = GameOfSet()
        game.dealTwelve()
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        removeCardsFromBoard()
        calculateGrid()
        drawCardsOnBoard()
        updateActionButtonLabel()
        updateTopLabels()
        audioAndHapticFeedback()
    }
    
    private func removeCardsFromBoard() {
        cardsInPlay = []
        view.subviews.filter{$0 is SetCardView}.forEach({$0.removeFromSuperview()}) //Filter all the views for type SetCardView then remove
    }
    
    private func calculateGrid() {
        let count = game.cardsInPlay.count //Count the cards on the board
        if count == 0 {return} //If no cards on board (ie game not started) abort
        let long = count.isqrt //Integer square root (ie whole number portion of the square root)
        let short = (count + long - 1) / long //Next whole number of ratio of count to count's integer square root
        if view.bounds.size.width > view.bounds.size.height { //If landscape mode
            grid.layout = .dimensions(rowCount: long, columnCount: short)
        } else { //Else for portrait mode
            grid.layout = .dimensions(rowCount: short, columnCount: long)
        }
        if let viewArea = view.viewWithTag(-1) { //Tagged play area as -1 so that cards could be tagged with positive integers
            grid.frame = viewArea.frame
        }
    }
    
    private func drawCardsOnBoard() {
        for index in game.cardsInPlay.indices { //Iterate through all the cards on board
            let card = game.cardsInPlay[index]
            if let frame = grid[index] { //Card frame derived from grid
                let cardView = SetCardView(card: card, frame: frame) //Create card object from custom class passing frame and card model
                cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                cardView.cardColor = cardColors[card.color.rawValue] //Use model property to index the card colors arrray
                cardsInPlay.append(cardView) //Insert card object into array of cards in play
            }
            if game.indexOfSelected.contains(index) { //If the card is one of the selected cards add a border highlight
                var color = selectionColors["select"]
                if let set = game.isASet { //If 3 are selected the highlight color is different
                    if set {
                        color = selectionColors["set"]
                    } else {
                        color = selectionColors["noset"]
                    }
                }
                cardsInPlay[index].highlightColor = color ?? #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            }
            view.addSubview(cardsInPlay[index]) //Add the card object as a subview
            cardsInPlay[index].tag = index + 1 //Tag the cards with index + 1 since tag 0 is used by default for all other views
        }
    }
    
    private func updateActionButtonLabel() {
        actionButtonLabel.isEnabled = true
        if let set = game.isASet { //If 3 are selected (ie is a set)
            if set {
                if game.cards.count > 0 { //Check cards left in deck
                    actionButtonLabel.setTitle("Replace Set", for: .normal) //Set with cards left in deck
                } else {
                    actionButtonLabel.setTitle("Clear Set", for: .normal) //Set but no cards left to replace the set with
                }
            } else {
                actionButtonLabel.setTitle("Clear", for: .normal) //3 selected but was not a set
            }
        } else { //Number of selected is not 3
            if game.cards.count == 0 { //Deck is empty
                actionButtonLabel.setTitle("No Cards Left", for: .normal) //Deck is empty and 3 are not selected
                actionButtonLabel.isEnabled = false
            } else {
                actionButtonLabel.setTitle("Add 3", for: .normal) //Deck is not empty and 3 are not selected
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
        //First check is to see if number of cards in play or out of play changed, and if so play card sound
        if game.cardsInPlay.count != cardsInPlayCount || game.cardsOutOfPlay.count != cardsOutOfPlayCount {
            cardsInPlayCount = game.cardsInPlay.count //After card count check, reset the count to current count
            cardsOutOfPlayCount = game.cardsOutOfPlay.count
            if game.cards.count == 69 { //69 indicates a new game has started to play new game sound
                playSound("cardShuffle", dot: "wav")
            } else {
                playSound("cardSlide6", dot: "wav")
            }
        }
        //Check for result of a card tap
        if let set = game.isASet { //If 3 are selected play set or no-set sound
            cardsSelectedCount = 0 //Reset the counter whenever 3 have been selected
            if set {
                playSound("ding", dot: "wav") //Set sound
            } else {
                playSound("error", dot: "wav") //No-set sound
            }
        } else if game.indexOfSelected.count > cardsSelectedCount { //Only play selected sound if the count is increasing
            cardsSelectedCount = game.indexOfSelected.count //After check for increasing selection count, reset counter to current count
            playSound("beep", dot: "wav") //Card selected sound
        }
        if game.indexOfSelected.count == 0 {cardsSelectedCount = 0} //Reset the counter if the last card tap resulted in zero selection count (ie deselection with only one selected
        hapticFeedback(called: "peek") //Every action gets a haptic shake
    }
    
    private func configureFonts() {
        scoreLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        remainingCardsLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        newGameButtonLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        settingsButtonLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        actionButtonLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title1)
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
    
    //Whole number only portion of the square root
    var isqrt: Int {
        if self > 0 {
            return Int(Double(self).squareRoot())
        } else
        {return 1}
    }
    
    
}

