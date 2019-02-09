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
    private var selectedCards: [SetCard] = []
    private var isASet: Bool? {
        get{
            guard selectedCards.count == 3 else {
                return nil
            }
            return selectedCards.map{$0.hashValue}.reduce(0, +) % 3 == 0
        }
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
        for _ in 1...number {
            inPlay.append(cards.remove(at: cards.count.rando))
        }
        //return Array(inPlay.suffix(number))
    }
    
    func cardSelected(_ card: SetCard) {
        if selectedCards.count == 3 {
            calculateScore()
        }
        if selectedCards.count == 4 {
            selectedCards = Array(selectedCards.suffix(1))
        }
        if selectedCards.contains(card) {
            selectedCards.remove(at: selectedCards.firstIndex(of: card) ?? 0)
        }
        
    }
    
    func calculateScore() {
        
    }
    
    func removeSelectedFromPlay() {
        if isASet! {
            for index in selectedCards.indices {
                inPlay.remove(at: inPlay.firstIndex(of: selectedCards[index]) ?? 0)
                
            }
        }
    }
}
