//
//  ViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

/*TODO:
game over detection - should be possible now that brute force solving is immplemented
Animations for cards
Card shadows
Animated popups for scoring
Settings menu
Help/Instructions
Timer based score modifiers
Light Mode/Dark Mode
Easy play mode (less card properties)
scoreboard

*/


import UIKit
import AVFoundation

class GameOfSetViewController: UIViewController, UIGestureRecognizerDelegate {

    
    //MARK: - Properties
    /***************************************************************/
    
    private let selectionColors = ["select":#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1),"set":#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),"noset":#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)] //Colors for the selection borders
    
    private var game = GameOfSet()
    private var grid = Grid(layout: .dimensions(rowCount: 4, columnCount: 3))
    private lazy var cardSize = grid[0]!.size
    private var cardsOnBoard: [SetCardView] = []
    
    //Counter variables to track game state
    private var cardsOnBoardCount = 0
    private var cardsOffBoardCount = 0
    private var cardsSelectedCount = 0 {
        didSet {
            if cardsSelectedCount == 3 { //Reset counter automatically so audio feedback works as intended
                cardsSelectedCount = 0
            }
        }
    }
    private var selectedCardIndex = 0 {
        didSet { //Updated by touch events and hints
            game.cardSelected(selectedCardIndex)
            updateViewFromModel()
        }
    }
    
    
    //MARK: - Init IBOutlets Actions
    /***************************************************************/
    
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var remainingCardsLabel: UILabel!
    
    @IBOutlet weak var setsButtonLabel: UIButton!
    @IBAction func setsButton(_ sender: UIButton) {
    }
    
    @IBOutlet private weak var actionButtonLabel: UIButton!
    @IBAction private func actionButton(_ sender: UIButton) {
        game.action()
        updateViewFromModel()
    }
    
    @IBOutlet weak var newGameButtonLabel: UIButton!
    @IBAction private func newGameButton(_ sender: UIButton) {
        newGame()
    }
    
    @IBOutlet weak var hintButtonLabel: UIButton!
    @IBAction private func hintButton(_ sender: UIButton) { //Clears selected without penalty and selects one card guaranteed to be in a set
        var hintSet = game.indicesOfSets[game.indicesOfSets.count.rando] //Get a random set; button disabled if no sets available
        game.clearSelected()
        cardsSelectedCount = 0
        game.cardSelected(hintSet.remove(at: hintSet.count.rando)) //Get a random card
        updateViewFromModel()
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func viewDidLoad() {
        //Inital board setup
        hintButtonLabel.isEnabled = false
        actionButtonLabel.isEnabled = false
        actionButtonLabel.setTitle("", for: .normal)
        setsButtonLabel.isEnabled = false
        setsButtonLabel.setTitle("", for: .normal)
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
        //Update the views if the game is started or the main frame size changes
        if view.viewWithTag(-1)!.frame != grid.frame && game.cardInPlay.count > 0 {
            updateViewFromModel()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        //Handle font size accessiblity settings
        configureFonts()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        //Shaking toggles test mode for testing end-game
        game.testMode = !game.testMode
        updateViewFromModel()
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    //This function serves to get the index of the card that was tapped and caused me trouble because of the symbol subviews that were untagged; My fix is to add the tapped view and super view tags together; either you tapped a symbol and the super view is the correct tag or you tapped a card and the zero tag game board is the super; either way the sum is the number I want; I will clean this up once I learn a better way
    @objc private func handleTap(gestureRecognizer: UITapGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            if game.cardInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            let view = gestureRecognizer.view //Being verbose since this part is confusing
            let loc = gestureRecognizer.location(in: view) //Get the location of the tap
            if let cardView = view { //Unwrap the view the tap recognized
                if let sub = cardView.hitTest(loc, with: nil) { //Unwrap the subview at the tap location (not sure what the 'with: nil' parameter is)
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
            if game.cardInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            actionButtonLabel.sendActions(for: .touchUpInside) //Swipe down just duplicates the Action button function
        default: break
        }
    }
    
    @objc private func handleRotate(gestureRecognizer: UIRotationGestureRecognizer) {
        switch gestureRecognizer.state {
        case .ended:
            if game.cardInPlay.count == 0 {newGame(); return} //Gesture on empty game board will start a new game
            game.shuffleCardsInPlay()
            updateViewFromModel()
        default: break
        }
    }
    
    private func newGame() {
        //Set up game board
        actionButtonLabel.isEnabled = true
        setsButtonLabel.isEnabled = true
        remainingCardsLabel.isHidden = false
        
        //Initialize game variables
        cardsOnBoardCount = 0
        cardsOffBoardCount = 0
        cardsSelectedCount = 0
        
        //Create new game object and deal
        game = GameOfSet()
        game.dealTwelve()
        
        updateViewFromModel()
    }
    
    private func updateViewFromModel() {
        removeCardsFromBoard()
        calculateGrid()
        drawCardsOnBoard()
        updateBottomLabels()
        updateTopLabels()
        audioAndHapticFeedback()
    }
    
    private func removeCardsFromBoard() {
        cardsOnBoard = []
        view.subviews.filter{$0 is SetCardView}.forEach({$0.removeFromSuperview()}) //Filter all the views for type SetCardView then remove
    }
    
    private func calculateGrid() {
        let count = game.cardInPlay.count //Count the cards on the board
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
    
    private enum CardState {
        case unchanged
        case deal
        case discard
        case selected
    }
    
    
    private func indexChangedCards() -> ([Int],CardState) {
        let difference = game.cardInPlay.count - cardsOnBoardCount
        switch difference {
        case _ where difference < 0:
            return (Array(game.cardOutOfPlay.indices.suffix(3)),.discard)
        case _ where difference > 0:
            return (Array(game.cardInPlay.indices.suffix(difference)),.deal)
        default:
            return (game.indexOfSelected,.selected)
        }
    }
    
    private func drawCardsOnBoard() {
        let (changedCardsIndices,state) = indexChangedCards()
        print(changedCardsIndices)
        var counter = 0
        for index in game.cardInPlay.indices { //Iterate through all the cards on board
            let card = game.cardInPlay[index]
            var startFrame = grid[index]!
            var endFrame = setsButtonLabel.frame
            var face = true
            var moveAndFlip = false
            if changedCardsIndices.contains(index) {
                switch state {
                case .deal:
                    face = false
                    moveAndFlip = true
                    startFrame = actionButtonLabel.frame
                    endFrame = grid[index]!
                case .discard:
                    moveAndFlip = true
                case .selected:
                    break
                default: break
                }
            }
            let cardView = SetCardView(card: card, frame: startFrame, isFaceUp: face)
            cardView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            cardsOnBoard.append(cardView) //Insert card object into array of cards in play
            drawCardBorder(for: index)
            view.addSubview(cardsOnBoard[index]) //Add the card object as a subview
            cardsOnBoard[index].tag = index + 1 //Tag the cards with index + 1 since tag 0 is used by default for all other views
            if moveAndFlip {
                UIViewPropertyAnimator.runningPropertyAnimator(
                    withDuration: 0.5,
                    delay: 0.22 * Double(counter),
                    options: [.curveEaseInOut],
                    animations: {self.cardsOnBoard[index].frame = endFrame},
                    completion: {if $0 == .end {UIView.transition(
                        with: self.cardsOnBoard[index],
                        duration: 0.6,
                        options: [.curveEaseInOut,.transitionFlipFromTop],
                        animations: {self.cardsOnBoard[index].cardIsFaceUp = true} ,
                        completion: {finished in }
                        )}})
                counter += 1
            }
        }
    }
    
    private func dealView(index: Int) {
        
    }
    
    private func drawCardBorder(for index: Int) {
        if game.indexOfSelected.contains(index) { //If the card is one of the selected cards add a border highlight
            var color = selectionColors["select"]
            if let set = game.isASet { //If 3 are selected the highlight color is different
                if set {
                    color = selectionColors["set"]
                } else {
                    color = selectionColors["noset"]
                }
            }
            cardsOnBoard[index].highlightColor = color! //Force unwrap
        }
    }
    
    private func updateBottomLabels() {
        setsButtonLabel.setTitle("Sets: \(game.cardOutOfPlay.count / 3)", for: .normal)
        actionButtonLabel.isEnabled = true
        if let set = game.isASet { //If 3 are selected
            if set {
                if game.deck.count > 0 { //Check cards left in deck
                    actionButtonLabel.setTitle("Replace Set", for: .normal) //Set with cards left in deck
                } else {
                    actionButtonLabel.setTitle("Clear Set", for: .normal) //Set but no cards left to replace the set with
                }
            } else {
                actionButtonLabel.setTitle("Clear", for: .normal) //3 selected but was not a set
            }
        } else { //Number of selected is not 3
            if game.deck.count == 0 { //Deck is empty
                actionButtonLabel.setTitle("No Cards Left", for: .normal) //Deck is empty and 3 are not selected
                actionButtonLabel.isEnabled = false
            } else {
                actionButtonLabel.setTitle("Add 3", for: .normal) //Deck is not empty and 3 are not selected
            }
        }
        if game.indicesOfSets.count > 0 { //Only enable hint button if there is a set on the board
            hintButtonLabel.isEnabled = true
        } else {
            hintButtonLabel.isEnabled = false
        }
        var sets = String(game.indicesOfSets.count)
        if game.indicesOfSets.count > 3 {sets = "3+"} //I cut off the brute force hint solver to avoid lag, so I wanted to indicate that
        hintButtonLabel.setTitle("Hint: " + sets, for: .normal) //Hint button displays the number of valid sets on board
    }
    
    private func updateTopLabels() {
        remainingCardsLabel.text = "Cards Remaining: \(game.deck.count)"
        if game.testMode {
            scoreLabel.text = "TEST MODE"
        } else {
            scoreLabel.text = "Score: \(game.score)"
        }
    }
    
    private func audioAndHapticFeedback() {
        //First check is to see if number of cards in play or out of play changed, and if so play card sound
        if game.cardInPlay.count != cardsOnBoardCount || game.cardOutOfPlay.count != cardsOffBoardCount {
            cardsOnBoardCount = game.cardInPlay.count //After card count check, set the count to current count
            cardsOffBoardCount = game.cardOutOfPlay.count
            if game.deck.count == 69 { //69 indicates a new game has started
                playSound("cardShuffle", dot: "wav") //New game sound
            } else {
                playSound("cardSlide6", dot: "wav") //Cards changed sound
            }
        }
        //Check for result of a card tap
        if let set = game.isASet { //If 3 are selected play set or no-set sound
            if set {
                playSound("ding", dot: "wav") //Set sound
            } else {
                playSound("error", dot: "wav") //No-set sound
            }
        }
        if game.indexOfSelected.count > cardsSelectedCount { //Only play selected sound if the count is increasing
            playSound("beep", dot: "wav") //Card selected sound
        }
        cardsSelectedCount = game.indexOfSelected.count
        hapticFeedback(called: "peek") //Every view update gets a haptic shake
    }
    
    private func configureFonts() {
        scoreLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        remainingCardsLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        newGameButtonLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        hintButtonLabel.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
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

