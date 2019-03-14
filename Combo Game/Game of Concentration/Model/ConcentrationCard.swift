//
//  ConcentrationCard.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 3/12/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

struct Card: Hashable {
    
    //Implementing the hashable protocol
    var hashValue : Int {return identifier}
    //Implementing the equatable protocol
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false
    var isMatched = false
    var alreadySeen = false
    private var identifier: Int
    
    private static var identifierGenerator = 0
    private static func getUniqueIdentifier() -> Int {
        identifierGenerator += 1
        return identifierGenerator
    }
    
    init() {
        identifier = Card.getUniqueIdentifier()
    }
    
    
    
}
