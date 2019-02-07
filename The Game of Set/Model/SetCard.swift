//
//  SetCard.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

struct SetCard: Hashable, CustomStringConvertible {
    
    var description: String {return "\(color)\(shape)\(fill)\(count)"} //Custom String Convertible implementation
    
    var hashValue : Int {return cardHash} //Hashable implementation
    static func == (lhs: SetCard, rhs: SetCard) -> Bool { //Equatable implementation required by Hashable
        return lhs.cardHash == rhs.cardHash
    }
    
    private var cardHash: Int { //Unique descriptor of each card
        return Int(color.description + shape.description + fill.description + count.description) ?? 10000
    }
    
    //MARK: - Properties
    /***************************************************************/
    
    //SetCard has four properties
    
    var color: Color
    var shape: Shape
    var fill: Fill
    var count: Count
    
    
    //MARK: - Types
    /***************************************************************/
    
    //SetCard defines four Types, one for each property
    
    enum Color: String, CustomStringConvertible { //Define Color Type
        var description: String {return String(rawValue.last ?? "0")}
        
        case color1
        case color2
        case color3
        
        static var all = [Color.color1, .color2, .color3]
    }
    
    enum Shape: String, CustomStringConvertible { //Define Shape Type
        var description: String {return String(rawValue.last ?? "0")}
        
        case shape1
        case shape2
        case shape3
        
        static var all = [Shape.shape1, .shape2, .shape3]
    }
    
    enum Fill: String, CustomStringConvertible { //Define Fill Type
        var description: String {return String(rawValue.last ?? "0")}
        
        case fill1
        case fill2
        case fill3
        
        static var all = [Fill.fill1, .fill2, .fill3]
    }
    
    enum Count: String, CustomStringConvertible { //Define Count Type
        var description: String {return String(rawValue.last ?? "0")}
        
        case count1
        case count2
        case count3
        
        static var all = [Count.count1, .count2, .count3]
    }
}

