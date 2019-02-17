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
    
    func action() {
        if isASet != nil {
            resetSelectedCards()
        } else {
            for _ in 1...3 {
                if let newCard = getRandomCard() {
                    cardsInPlay.append(newCard)
                }
            }
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if indexOfSelected.contains(cardIndex) {
            if isASet != nil {
                resetSelectedCards()
            } else {
                indexOfSelected.remove(at: indexOfSelected.firstIndex(of: cardIndex)!)
                score -= 1
            }
        } else {
            if isASet != nil {
                resetSelectedCards()
            }
            indexOfSelected.append(cardIndex)
        }
    }
    
    func resetSelectedCards() {
        
        if isASet ?? false {
            replaceSet()
            score += 3
        } else {
            score -= 5
        }
        indexOfSelected = []
    }
    
    func replaceSet() {
        for item in indexOfSelected {
            if let newCard = getRandomCard() {
                cardsInPlay[item] = newCard
            } else {
                indexOfOutOfPlay.append(item)
            }
        }
    }
    
    func newGame() {
        resetSelectedCards()
        score = 0
        indexOfOutOfPlay = []
        for _ in 1...4 {action()}
    }
    
}
