//
//  GameOfSet.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

class GameOfSet {
    
    var testMode = false //Activate with shake gesture so end of game conditions can be tested

    private(set) var cards = [SetCard]()
    private(set) var score = 0
    private(set) var cardsInPlay: [SetCard] = []
    private(set) var cardsOutOfPlay: [SetCard] = []
    private(set) var indexOfSelected: [Int] = []
    
    var isASet: Bool? { //Main game logic
        guard indexOfSelected.count == 3 else {return nil} //Optional is nil until 3 cards have been selected
        var selectedCards = [SetCard]()
        for item in indexOfSelected {
            selectedCards.append(cardsInPlay[item]) //Create array of 3 selected cards
        }
        if testMode {return true} //Any 3 are a match in test mode
        return (Array(String(selectedCards.map{ $0.hashValue }.reduce(0, +))).filter{ $0 != "0" && $0 != "3" && $0 != "6" }.count) == 0 //Adds up the numeric values (0, 1, or 2) of each property of the 3 selected cards - Only correct sets will sum to a multiple of 3. If the count of non 3 multiples is zero, return true (it is a set).
    }
    
    
    //MARK: - Init
    /***************************************************************/
    
    init() { //Initialize every combination of the card properties (4 properites with 3 variants each = 81 total cards)
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all {
                for fill in SetCard.Fill.all {
                    for pips in SetCard.Pips.all {
                        cards.append(SetCard(color: color, shape: shape, fill: fill, pips: pips))
                    }
                }
            }
        }
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    func getRandomCard() -> SetCard? {
        if cards.count == 0 {return nil}
        return cards.remove(at: cards.count.rando)
    }
    
    //Main action button adds three cards to the play area, unless the reset flag has been set
    func action() {
        if resetRequired() {
        } else {
            for _ in 1...3 {
                if let newCard = getRandomCard() {
                    cardsInPlay.append(newCard)
                }
            }
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if indexOfSelected.contains(cardIndex) { //Selecting a card that is already selected
            if resetRequired() { //Check if reset is needed
            } else { //If less than 3 selected, deselect the selected
                indexOfSelected.remove(at: indexOfSelected.firstIndex(of: cardIndex)!)
                score -= 1 //Score penalty for deselection
            }
        } else { //Selecting a card that is not already selected
            if resetRequired() {} //Check if reset is needed
            indexOfSelected.append(cardIndex) //Select new card
        }
    }
    
    func resetRequired() -> Bool {
        if isASet != nil { //Check if 3 cards are selected
            resetSelectedCards()
            return true
        } else {
            return false
        }
    }
    
    func resetSelectedCards() {
        if isASet ?? false {
            replaceSet()
            score += 5
        } else {
            score -= 5
        }
        indexOfSelected = []
    }
    
    func replaceSet() {
        for item in indexOfSelected.sorted(by: >) { //Must replace in reverse order to prevent index errors
            if let newCard = getRandomCard() { //Only replaces if cards are available
                let oldCard = cardsInPlay[item]
                cardsOutOfPlay.append(oldCard)
                cardsInPlay[item] = newCard
            } else {
                cardsOutOfPlay.append(cardsInPlay.remove(at: item)) //If no cards available, just remove from play
            }
        }
    }
    
    func newGame() {
        resetSelectedCards()
        score = 0
        cardsOutOfPlay = []
        for _ in 1...4 {action()}
    }
    
}
