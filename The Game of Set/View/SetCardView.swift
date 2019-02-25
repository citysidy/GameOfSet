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
    
    
    //MARK: - IBOutlets and Actions
    /***************************************************************/
    
    
    
    
    //MARK: - Methods
    /***************************************************************/
    
    private func shape0() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.midX, y: 0))
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func draw(_ rect: CGRect) {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
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
    }
    
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    
}

extension CGRect {
    
    var topThird: CGRect {
        return CGRect(x: minX, y: minY, width: width, height: height/3)
    }
    
    var middleThird: CGRect {
        return CGRect(x: minX, y: minY+height/3, width: width, height: height/3)
    }
    
    var bottomThird: CGRect {
        return CGRect(x: minX, y: maxY-height/3, width: width, height: height/3)
    }
    
    var topOffsetThird: CGRect {
        return CGRect(x: minX, y: minY+height/6, width: width, height: height/3)
    }
    
    var bottomOffsetThird: CGRect {
        return CGRect(x: minX, y: midY, width: width, height: height/3)
    }
    
    func inset(by size: CGSize) -> CGRect {
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect {
        return CGRect(origin: origin, size: size)
    }
    
    
}
