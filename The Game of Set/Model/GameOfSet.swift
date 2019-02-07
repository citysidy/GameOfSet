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
    private(set) var cards = [SetCard]()
    
    //MARK: - Init
    /***************************************************************/
    
    init() {
        for color in SetCard.Color.all {
            for shape in SetCard.Shape.all {
                for fill in SetCard.Fill.all {
                    for count in SetCard.Count.all {
                        cards.append(SetCard(color: color, shape: shape, fill: fill, count: count))
                    }
                }
            }
        }
        if debug {print(cards.count)}
    }
    
}
