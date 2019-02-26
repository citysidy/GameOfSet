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
    
    private lazy var symbolMiddle: UIView = createMiddleSubView()
    private lazy var symbolTop: UIView = createMiddleSubView()
    private lazy var symbolBottom: UIView = createMiddleSubView()
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    
    
    
    //MARK: - Methods
    /***************************************************************/
    
    private func shape0() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: 0))
    }
    
    private func createMiddleSubView() -> UIView {
        let frame = bounds.middleSquare
        let subView = UIView()
        subView.frame.size = CGSize.zero
        subView.frame = frame//.insetBy(dx: symbolSpacing, dy: symbolSpacing)
        subView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.6549019608, blue: 0.2039215686, alpha: 1)
        return subView
    }
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func layoutSubviews() {
        super.layoutSubviews()
        symbolMiddle.center = CGPoint(x: bounds.midX, y: bounds.midY)
        symbolTop.center = CGPoint(x: bounds.topThird.midX, y: bounds.topThird.midY)
        symbolBottom.center = CGPoint(x: bounds.bottomThird.midX, y: bounds.bottomThird.midY)
    }
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds.insetBy(dx: cardSpacing, dy: cardSpacing), cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        //symbolFrames[0] = UIView(frame: bounds.middleSquare)
        self.addSubview(symbolMiddle)
        self.addSubview(symbolTop)
        self.addSubview(symbolBottom)
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
        static let symbolOffsetToBoundsHeight: CGFloat = 0.01
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
            
        } else {
            side = width/3
            
        }
        return CGRect(x: minX, y: minY, width: side, height: side)
    }
    
    var topThird: CGRect {
        return CGRect(x: minX, y: minY, width: width, height: height/3)
    }
    
    var bottomThird: CGRect {
        return CGRect(x: minX, y: maxY-height/3, width: width, height: height/3)
    }
    
    var topOffsetHalf: CGRect {
        return CGRect(x: minX, y: minY+height/6, width: width, height: height/3)
    }
    
    var bottomOffsetHalf: CGRect {
        return CGRect(x: minX, y: midY, width: width, height: height/3)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    
}
