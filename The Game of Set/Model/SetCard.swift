//
//  SetCard.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

struct SetCard: Hashable, CustomStringConvertible {
    
    var hashValue : Int {return cardHash}
    var description: String {return "\(color)\(shape)\(fill)\(count)"}
    
    static func == (lhs: SetCard, rhs: SetCard) -> Bool {
        return lhs.cardHash == rhs.cardHash
    }
    
    private var cardHash: Int {
        return Int(color.description + shape.description + fill.description + count.description) ?? 10000
    }
    
    var color: Color
    var shape: Shape
    var fill: Fill
    var count: Count
    
    enum Color: String, CustomStringConvertible {
        var description: String {return String(rawValue.last ?? "0")}
        
        case color1
        case color2
        case color3
        
        static var all = [Color.color1, .color2, .color3]
    }
    
    enum Shape: String, CustomStringConvertible {
        var description: String {return String(rawValue.last ?? "0")}
        
        case shape1
        case shape2
        case shape3
        
        static var all = [Shape.shape1, .shape2, .shape3]
    }
    
    enum Fill: String, CustomStringConvertible {
        var description: String {return String(rawValue.last ?? "0")}
        
        case fill1
        case fill2
        case fill3
        
        static var all = [Fill.fill1, .fill2, .fill3]
    }
    
    enum Count: String, CustomStringConvertible {
        var description: String {return String(rawValue.last ?? "0")}
        
        case count1
        case count2
        case count3
        
        static var all = [Count.count1, .count2, .count3]
    }
}

