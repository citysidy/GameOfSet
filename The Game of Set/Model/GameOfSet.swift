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
    private(set) var cardsOutOfPlay: [SetCard] = []
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
        if indexOfSelected.contains(cardIndex) {
            if resetRequired() {
            } else {
                indexOfSelected.remove(at: indexOfSelected.firstIndex(of: cardIndex)!)
                score -= 1
            }
        } else {
            if resetRequired() {}
            indexOfSelected.append(cardIndex)
        }
    }
    
    func resetRequired() -> Bool {
        if isASet != nil {
            resetSelectedCards()
            return true
        } else {
            return false
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
        for item in indexOfSelected.sorted(by: >) {
            if let newCard = getRandomCard() {
                let oldCard = cardsInPlay[item]
                cardsOutOfPlay.append(oldCard)
                cardsInPlay[item] = newCard
            } else {
                cardsOutOfPlay.append(cardsInPlay.remove(at: item))
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
