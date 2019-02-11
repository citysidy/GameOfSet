//
//  GameOfSet.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

class GameOfSet {
    
    private var cards = [SetCard]()
    private var resetOnNext = false
    
    private(set) var score = 0
    private(set) var cardsInPlay: [SetCard] = []
    private(set) var indexOfSelected: [Int] = []
    
    var cardsRemaining: Int {
        return 81 - cards.count
    }
    var isASet: Bool? {
        guard indexOfSelected.count == 3 else {return nil}
        var selectedCards = [SetCard]()
        for item in indexOfSelected {
            selectedCards.append(cardsInPlay[item])
        }
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
    
    func getRandomCard() -> SetCard {
        return cards.remove(at: cards.count.rando)
    }
    
    func deal(_ number: Int) {
        guard cards.count >= number else {
            return
        }
        for _ in 1...number {
            cardsInPlay.append(getRandomCard())
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if resetOnNext {
            resetSelectedCards()
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
        guard cards.count >= indexOfSelected.count else {return}
        for item in indexOfSelected {
            cardsInPlay[item] = getRandomCard()
        }
    }
    
    func calculateScore() {
        if isASet! {
            print("Set!\n")
            score += 5
        } else {
            print("No Set\n")
            score -= 5
        }
    }
    
    
    
}
