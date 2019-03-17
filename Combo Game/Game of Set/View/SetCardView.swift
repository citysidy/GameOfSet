//
//  SetCardView.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/25/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    
    //MARK: - Properties
    /***************************************************************/
    
    private let cardSymbolColors = [#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1),#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1),#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)] //Colors for the card symbols

    private let cardFace: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    private let cardBack: UIColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    
    private let cardFrame: CGRect
    private let colorIndex: Int
    private let cardSymbol: Int
    private let cardFill: Int
    private let cardPips: Int
    
    var cardIsFaceUp: Bool {didSet{setNeedsDisplay()}}
    
    private var symbolSubView: [SymbolView] = [] //Array to hold the symbols
    
    var highlightColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)    
    
    
    //MARK: - Init IBOutlets Actions
    /***************************************************************/
    
    init(card: SetCard, frame: CGRect, isFaceUp: Bool) { //Using initializer instead of dummy values
        cardFrame = frame
        colorIndex = card.color.rawValue
        cardSymbol = card.shape.rawValue
        cardFill = card.fill.rawValue
        cardPips = card.pips.rawValue
        cardIsFaceUp = isFaceUp
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) { //Required but I don't know what it means
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cardBounds = bounds.insetBy(dx: cardSpacing, dy: cardSpacing)
        switch symbolSubView.count {
        case 2:
            symbolSubView.first?.center = CGPoint(x: cardBounds.topOffsetHalf.midX, y: cardBounds.topOffsetHalf.midY)
            symbolSubView.last?.center = CGPoint(x: cardBounds.bottomOffsetHalf.midX, y: cardBounds.bottomOffsetHalf.midY)
        case 3:
            symbolSubView[1].center = CGPoint(x: cardBounds.topThird.midX, y: cardBounds.topThird.midY)
            symbolSubView.last?.center =  CGPoint(x: cardBounds.bottomThird.midX, y: cardBounds.bottomThird.midY)
            fallthrough //Fallthrough since the 3 case and 1 case both use the middle symbol
        case 1:
            symbolSubView.first?.center = CGPoint(x: bounds.midX, y: bounds.midY)
        default: break
        }
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds.insetBy(dx: cardSpacing, dy: cardSpacing), cornerRadius: cornerRadius)
        if cardIsFaceUp {
            cardFace.setFill()
        } else {
            cardBack.setFill()
        }
        highlightColor.setStroke()
        roundedRect.lineWidth = strokeWidth
        roundedRect.stroke()
        roundedRect.fill()
        addSubViews()
    }
    
    
    //MARK: - Methods
    /***************************************************************/
    
    //Generate the subviews
    private func addSubViews() {
        if cardIsFaceUp {
            for index in 0...cardPips {
                let symbolView = SymbolView()
                symbolView.symbolType = cardSymbol
                symbolView.symbolColor = cardSymbolColors[colorIndex]
                symbolView.symbolFill = cardFill
                symbolView.frame = bounds.insetBy(dx: cardSpacing, dy: cardSpacing).thirds
                symbolView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                symbolSubView.append(symbolView)
                self.addSubview(symbolSubView[index])
            }
        }
    }
    
    
}


//MARK: - Extension
/***************************************************************/

extension SetCardView {
    
    //Constants
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardSpacingToBoundsHeight: CGFloat = 0.03
        static let strokeToBoundsHeight: CGFloat = 0.05
    }
    
    private var strokeWidth: CGFloat {
        let side = max(bounds.maxX, bounds.maxY)
        return side * SizeRatio.strokeToBoundsHeight
    }
    
    private var cornerRadius: CGFloat {
        let side = max(bounds.maxX, bounds.maxY)
        return side * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cardSpacing: CGFloat {
        let side = max(bounds.maxX, bounds.maxY)
        return side * SizeRatio.cardSpacingToBoundsHeight
    }
    
    
}


extension CGRect {
    
    //Used to layout the symbol subview loctions
    var thirds: CGRect {
        let width = min(maxX, maxY)
        let height = max(maxX, maxY) / 3
        let side = min(width, height)
        return CGRect(x: minX, y: minY, width: side, height: side)
    }
    
    var topThird: CGRect {
        if maxY > maxX {
            return CGRect(x: minX, y: minY, width: width, height: height/3)
        } else {
            return CGRect(x: minX, y: minY, width: width/3, height: height)
        }
    }
    
    var bottomThird: CGRect {
        if maxY > maxX {
            return CGRect(x: minX, y: maxY-height/3, width: width, height: height/3)
        } else {
            return CGRect(x: maxX-width/3, y: minY, width: width/3, height: height)
        }
    }
    
    var topOffsetHalf: CGRect {
        if maxY > maxX {
            return CGRect(x: minX, y: midY-height/3, width: width, height: height/3)
        } else {
            return CGRect(x: midX-width/3, y: minY, width: width/3, height: height)
        }
    }
    
    var bottomOffsetHalf: CGRect {
        if maxY > maxX {
            return CGRect(x: minX, y: midY, width: width, height: height/3)
        } else {
            return CGRect(x: midX, y: minY, width: width/3, height: height)
        }
    }
    
    
}
