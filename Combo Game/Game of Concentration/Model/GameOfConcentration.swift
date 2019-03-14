//
//  GameOfConcentration.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 3/12/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

struct Concentration {
    
    private var debug = true
    
    private(set) var flips = 0
    private(set) var score = 0
    private(set) var deck = [Card]()
    private var indexOfOneAndOnlyFaceUp: Int? {
        get {
            return deck.indices.filter{deck[$0].isFaceUp}.oneAndOnly //Returns index of only face up card if it exists
        }
        set {
            for index in deck.indices {
                deck[index].isFaceUp = (index == newValue) //
            }
            currentStatus = .firstChoice
        }
    }
    
    private var numberOfUnmatchedCards: Int {
        return  (deck.count - (deck.indices.filter{deck[$0].isMatched}.count)) //Number of unmatched cards left
    }
    
    var currentStatus: Status
    
    enum Status: String {
        case cardMatch
        case noMatch
        case firstChoice
        case gameOver
        case newGame
    }
    
    mutating func chooseCard(at index: Int) {
        //Main game logic function
        assert(deck.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards array")
        if let matchIndex = indexOfOneAndOnlyFaceUp { //Index the face up card if it exists
            deck[index].isFaceUp = true //Card chosen is turned face up
            if deck[matchIndex] == deck[index] { //Check if chosen card matches face up card
                deck[matchIndex].isMatched = true
                deck[index].isMatched = true
                score += 2
                if numberOfUnmatchedCards == 0 {
                    currentStatus = .gameOver
                } else {
                    currentStatus = .cardMatch
                }
            } else {
                currentStatus = .noMatch
                if deck[index].alreadySeen {score -= 1}
                if deck[matchIndex].alreadySeen {score -= 1}
                deck[index].alreadySeen = true
                deck[matchIndex].alreadySeen = true
            }
        } else { //Since no face up card exists, set the chosen card as the face up card
            indexOfOneAndOnlyFaceUp = index
        }
        flips += 1
    }
    
    func over() -> Bool {
        return numberOfUnmatchedCards == 0
    }
    
    init(numberOfPairsOfCards: Int) {
        //Build a deck
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            deck += [card, card] //Cards inserted in pairs
        }
        var shuffledCards = [Card]() //Shuffle the cards
        while deck.count > 0 {
            shuffledCards.append(deck.remove(at: deck.count.rando))
        }
        deck = shuffledCards
        currentStatus = .newGame
    }
    
    
}


extension Collection {
    //If the collection only contains one element, return that element, otherwise nil
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
    
    
}
