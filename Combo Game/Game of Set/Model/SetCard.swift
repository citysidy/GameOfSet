//
//  SetCard.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/6/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import Foundation

struct SetCard: CustomStringConvertible, Hashable {
    
    var description: String {return "\(color) \(shape) \(fill) \(pips)"} //Custom String Convertible implementation
    var hashValue : Int { //Hashable implementation
        return (10000 + color.rawValue * 1000 + shape.rawValue * 100 + fill.rawValue * 10 + pips.rawValue)
    }
    static func == (lhs: SetCard, rhs: SetCard) -> Bool { //Equatable implementation required by Hashable
        return lhs.hashValue == rhs.hashValue
    }
    
    
    //MARK: - Properties
    /***************************************************************/
    
    //SetCard has five properties
    let color: Color
    let shape: Shape
    let fill: Fill
    let pips: Pips
        
    //MARK: - Types
    /***************************************************************/
    
    //SetCard defines four Types, one for each property
    enum Color: Int, CustomStringConvertible { //Define Color Type
        var description: String {return "Color:\(rawValue)"}
        
        case c0
        case c1
        case c2
        
        static var all = [Color.c0, .c1, .c2]
    }
    
    enum Shape: Int, CustomStringConvertible { //Define Shape Type
        var description: String {return "Shape:\(rawValue)"}
        
        case s0
        case s1
        case s2
        
        static var all = [Shape.s0, .s1, .s2]
    }
    
    enum Fill: Int, CustomStringConvertible { //Define Fill Type
        var description: String {return "Fill:\(rawValue)"}
        
        case f0
        case f1
        case f2
        
        static var all = [Fill.f0, .f1, .f2]
    }
    
    enum Pips: Int, CustomStringConvertible { //Define Count Type
        var description: String {return "Pips:\(rawValue)"}
        
        case p0
        case p1
        case p2
        
        static var all = [Pips.p0, .p1, .p2]
    }
}

