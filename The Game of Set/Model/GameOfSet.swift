//
//  GameOfSet.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

class GameOfSet {
    
    private var debug = true
    
    private(set) var score = 0
    private var cards = [SetCard]()
    private(set) var inPlay: [SetCard] = []
    private var outOfPlay: [SetCard] = []
    private(set) var indiciesOfSelectedCards: [Int] = []
    private var resetOnNext = false
    private var isASet: Bool {
        var selectedCards = [SetCard]()
        for item in indiciesOfSelectedCards {
            selectedCards.append(inPlay[item])
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
            inPlay.append(getRandomCard())
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if resetOnNext {
            resetSelectedCards()
        }
        if indiciesOfSelectedCards.contains(cardIndex) {
            indiciesOfSelectedCards.remove(at: indiciesOfSelectedCards.firstIndex(of: cardIndex)!)
        } else {
            indiciesOfSelectedCards.append(cardIndex)
            checkForSet()
        }
    }
    
    func calculateScore() {
        print("Calculate Score\n")
    }
    
    func checkForSet() {
        guard indiciesOfSelectedCards.count == 3 else {
            return
        }
        resetOnNext = true
        if isASet {
            print("Set!")
            print(indiciesOfSelectedCards)
        } else {
            print("No Set")
        }
        calculateScore()
    }
    
    func resetSelectedCards() {
        print("Reset Selected Cards")
        resetOnNext = false
        print(indiciesOfSelectedCards)
        if isASet {
            for item in indiciesOfSelectedCards {
                print(item)
                inPlay[item] = getRandomCard()
            }
        }
        indiciesOfSelectedCards = []
    }
    
    
    
}
