//
//  SetCardView.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/25/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    //MARK: - Properties
    /***************************************************************/
    
    @IBInspectable
    var cardBackgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable
    var symbolBackgroundColor: UIColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    @IBInspectable
    var color: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var shape: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var fill: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    @IBInspectable
    var pips: Int = 0 {didSet {setNeedsDisplay(); setNeedsLayout()}}
    
    private var numberOfSubViews: Int {
        return pips + 1
    }
    
    private var symbolSubView: [SymbolView] = []
    
    private lazy var symbolMiddle: SymbolView = createSubView()
    private lazy var symbolTop: SymbolView = createSubView()
    private lazy var symbolBottom: SymbolView = createSubView()
    private lazy var symbolTopHalf: SymbolView = createSubView()
    private lazy var symbolBottomHalf: SymbolView = createSubView()
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    
    
    
    //MARK: - Methods
    /***************************************************************/
    
    private func createSubView() -> SymbolView {
        let subView = SymbolView()
        subView.symbol = shape
        subView.fill = fill
        subView.color = color
        subView.frame.size = CGSize.zero
        subView.backgroundColor = symbolBackgroundColor
        return subView
    }
    
    private func addSubViews() {
        switch numberOfSubViews {
        case 2:
            self.addSubview(symbolTopHalf)
            self.addSubview(symbolBottomHalf)
        case 3:
            self.addSubview(symbolTop)
            self.addSubview(symbolBottom)
            fallthrough
        default:
            self.addSubview(symbolMiddle)
        }
    }
    
    private func configureSubView(_ view: UIView) {
        view.frame = bounds.insetBy(dx: cardSpacing, dy: cardSpacing).middleSquare.insetBy(dx: symbolSpacing, dy: symbolSpacing)
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureSubView(symbolMiddle)
        configureSubView(symbolTop)
        configureSubView(symbolBottom)
        configureSubView(symbolTopHalf)
        configureSubView(symbolBottomHalf)
        symbolMiddle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        symbolTop.center = CGPoint(x: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).topThird.midX, y: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).topThird.midY)
        symbolBottom.center = CGPoint(x: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).bottomThird.midX, y: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).bottomThird.midY)
        symbolTopHalf.center = CGPoint(x: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).topOffsetHalf.midX, y: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).topOffsetHalf.midY)
        symbolBottomHalf.center = CGPoint(x: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).bottomOffsetHalf.midX, y: bounds.insetBy(dx: cardSpacing, dy: cardSpacing).bottomOffsetHalf.midY)
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds.insetBy(dx: cardSpacing, dy: cardSpacing), cornerRadius: cornerRadius)
        roundedRect.addClip()
        cardBackgroundColor.setFill()
        roundedRect.fill()
        addSubViews()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsLayout()
        setNeedsDisplay()
    }
    
    
}


//MARK: - Extension
/***************************************************************/

extension SetCardView {
    
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cardSpacingToBoundsHeight: CGFloat = 0.03
        static let symbolOffsetToBoundsHeight: CGFloat = 0.02
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var cardSpacing: CGFloat {
        return bounds.size.height * SizeRatio.cardSpacingToBoundsHeight
    }
    
    private var symbolSpacing: CGFloat {
        return bounds.size.height * SizeRatio.symbolOffsetToBoundsHeight
    }
    
}

extension CGRect {
    
    var middleSquare: CGRect {
        var side: CGFloat
        if maxY > maxX {
            side = height/3
            print("Portrait")
        } else {
            side = width/3
            print("Landscape")
        }
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
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    
}
