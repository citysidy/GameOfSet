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
    private var isASet: Bool? {
        var selectedCards = [SetCard]()
        for item in indiciesOfSelectedCards {
            selectedCards.append(inPlay[item])
        }
        guard selectedCards.count == 3 else {
            return nil
        }
        let selectedHashes = selectedCards.map{$0.hashValue}
        print(selectedHashes)
        let sum = selectedHashes.reduce(0, +)
        print(sum)
        let check = String(sum)
        let digits = Array(check)
        print(digits)
        let setTest = digits.filter{$0 != "0" && $0 != "3" && $0 != "6"}
        print(setTest.count)
        if setTest.count > 0 {
            return false
        }
        return true
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
    
    func deal(_ number: Int) {
        guard cards.count >= number else {
            return
        }
        for _ in 1...number {
            inPlay.append(cards.remove(at: cards.count.rando))
        }
    }
    
    func cardSelected(_ cardIndex: Int) {
        if indiciesOfSelectedCards.contains(cardIndex) {
            indiciesOfSelectedCards.remove(at: indiciesOfSelectedCards.firstIndex(of: cardIndex)!)
        } else {
            indiciesOfSelectedCards.append(cardIndex)
        }
        if indiciesOfSelectedCards.count == 3 {
            checkForSet()
        }
    }
    
    func calculateScore() {
        
    }
    
    func checkForSet() {
        if isASet! {
            print("Set!\n")
            for index in indiciesOfSelectedCards {
                print(index)
                //outOfPlay.append(inPlay.remove(at: index))
            }
        } else {
            print("No Set\n")
        }
    }
    
    
    
    
}
