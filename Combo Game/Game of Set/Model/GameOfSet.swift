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
    
    private(set) var score = 0
    private(set) var deck = [SetCard]()
    private(set) var cardInPlay: [SetCard] = [] {didSet{if cardInPlay.count > 2 {findSets()}}}
    private(set) var cardOutOfPlay: [SetCard] = []
    private(set) var indexOfSelected: [Int] = []
    private(set) var indicesOfSets: [[Int]] = []
    
    var isASet: Bool? { //Main game logic
        guard indexOfSelected.count == 3 else {return nil} //Optional is nil until 3 cards have been selected
        var selectedCards = [SetCard]()
        for item in indexOfSelected {
            selectedCards.append(cardInPlay[item]) //Create array of 3 selected cards
        }
        if testMode {return true} //Any 3 are a match in test mode
        return (Array(String(selectedCards.map{$0.hashValue}.reduce(0, +))).filter{$0 != "0" && $0 != "3" && $0 != "6"}.count) == 0 //Adds up the numeric values (0, 1, or 2) of each property of the 3 selected cards - Only correct sets will sum to a multiple of 3. If the count of non 3 multiples is zero, return true (it is a set).
    }
    
    
    //MARK: - Init IBOutlets Actions
    /***************************************************************/
    
    init() { //Initialize every combination of the card properties (4 properites with 3 variants each = 81 total cards)
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all {
                for fill in SetCard.Fill.all {
                    for pips in SetCard.Pips.all {
                        deck.append(SetCard(color: color, shape: shape, fill: fill, pips: pips))
                    }
                }
            }
        }
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    func dealTwelve() {
        for _ in 1...4 {action()} //Since action method deals 3 cards, we call it 4 times to get the starting 12 cards of a game
    }
    
    func shuffleCardsInPlay() {
        cardInPlay.shuffle() //Activated by the rotate gesture to shuffle the cards on the board
    }
    
    func clearSelected() {
        indexOfSelected = []
    }
    
    func action() {
        if indexOfSelected.count == 3 { //Action button reseets the selection if 3 are selected
            resetSelectedCards()
        } else {  //Action button deals 3 additional cards in most cases
            for _ in 1...3 {
                if let newCard = getRandomCard() {
                    cardInPlay.append(newCard)
                }
            }
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        var deselection = false
        if indexOfSelected.contains(cardIndex) { //Selecting a card that is already selected
            if indexOfSelected.count == 3 { //If you selected one of the 3 that were already selected then reset
                resetSelectedCards()
            } else { //If less than 3 selected, deselect the selected
                indexOfSelected.remove(at: indexOfSelected.firstIndex(of: cardIndex)!)
                deselection = true
            }
        } else { //Selecting a card that is not already selected
            if indexOfSelected.count == 3 { //Always reset if 3 were already selected
                resetSelectedCards()
            }
            indexOfSelected.append(cardIndex) //Select new card
        }
        calculateScore(didDeselect: deselection)
    }
    
    private func resetSelectedCards() {
        if isASet ?? false {
            replaceSet()
        }
        clearSelected()
    }
    
    private func replaceSet() {
        for item in indexOfSelected.sorted(by: >) { //Must replace in reverse order to prevent index errors
            if let newCard = getRandomCard() { //Only replaces if cards are available
                let oldCard = cardInPlay[item]
                cardOutOfPlay.append(oldCard)
                cardInPlay[item] = newCard
            } else {
                cardOutOfPlay.append(cardInPlay.remove(at: item)) //If no cards available, just remove from play
            }
        }
    }
    
    private func getRandomCard() -> SetCard? {
        if deck.count == 0 {return nil}
        return deck.remove(at: deck.count.rando)
    }
    
    private func calculateScore(didDeselect: Bool) {
        if didDeselect {
            score -= 1 //Penalty for deselecting
        }
        if let set = isASet {
            if set {
                score += 5 //Successful set
            } else {
                score -= 5 //No set penalty
            }
        }
    }
    
    private func findSets() { //Hint function brute forces sets on the board
        indicesOfSets = []
        mainLoop: for count1 in 0..<cardInPlay.count - 2 {
            for count2 in (count1 + 1)..<cardInPlay.count - 1 {
                for count3 in (count2 + 1)..<cardInPlay.count {
                    let testSet = [cardInPlay[count1],cardInPlay[count2],cardInPlay[count3]]
                    if (Array(String(testSet.map{$0.hashValue}.reduce(0, +))).filter{$0 != "0" && $0 != "3" && $0 != "6"}.count) == 0 {
                        indicesOfSets.append([count1,count2,count3])
                        if indicesOfSets.count > 3 { //Limiting to avoid delays when too many cards are on the board
                            break mainLoop
                        }
                    }
                }
            }
        }
    }
    
    
}
