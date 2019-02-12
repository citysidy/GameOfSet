//
//  GameOfSet.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

class GameOfSet {
    
    var testMode = false

    private(set) var cards = [SetCard]()
    private(set) var score = 0
    private(set) var cardsInPlay: [SetCard] = []
    private(set) var indexOfOutOfPlay: [Int] = []
    private(set) var indexOfSelected: [Int] = []
    private var resetOnNext = false
    
    var isASet: Bool? {
        guard indexOfSelected.count == 3 else {return nil}
        var selectedCards = [SetCard]()
        for item in indexOfSelected {
            selectedCards.append(cardsInPlay[item])
        }
        if testMode {return true}
        return (Array(String(selectedCards.map{$0.hashValue}.reduce(0, +))).filter{$0 != "0" && $0 != "3" && $0 != "6"}.count) == 0
    }
    
    
    //MARK: - Init
    /***************************************************************/
    
    init() {
        print("Game Of Set Initialized\n")
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
    
    func getRandomCard() -> SetCard {
        return cards.remove(at: cards.count.rando)
    }
    
    func deal(_ number: Int) {
        if indexOfSelected.count == 3 {
            resetSelectedCards()
        } else {
            guard cards.count > 0 else {return}
            for _ in 1...number {
                cardsInPlay.append(getRandomCard())
            }
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if resetOnNext {
            resetSelectedCards()
            return
        }
        if indexOfSelected.contains(cardIndex) {
            indexOfSelected.remove(at: indexOfSelected.firstIndex(of: cardIndex)!)
        } else {
            indexOfSelected.append(cardIndex)
            checkForThree()
        }
    }
    
    func checkForThree() {
        guard isASet != nil else {return}
        resetOnNext = true
        calculateScore()
    }
    
    func resetSelectedCards() {
        resetOnNext = false
        if isASet ?? false {
            replaceSet()
        }
        indexOfSelected = []
    }
    
    func replaceSet() {
        for item in indexOfSelected {
            if cards.count > 0 {
                cardsInPlay[item] = getRandomCard()
            } else {
                indexOfOutOfPlay.append(item)
            }
        }
    }
    
    func calculateScore() {
        if isASet! {
            score += 5
        } else {
            score -= 5
        }
    }
    
    func newGame() {
        score = 0
        cardsInPlay = []
        indexOfOutOfPlay = []
        indexOfSelected = []
        resetOnNext = false
    }
    
}
