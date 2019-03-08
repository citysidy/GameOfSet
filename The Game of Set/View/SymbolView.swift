//
//  SymbolView.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 2/28/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit

class SymbolView: UIView {
    
    
    //MARK: - Properties
    /***************************************************************/
    
    private let symbolColors = [#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
    
    private var path = UIBezierPath()
    
    private var strokeWidth: CGFloat {
        return bounds.size.height * 0.05
    }
    
    var colorIndex: Int = 0
    var symbol: Int = 0
    var symbolFill: Int = 0
    
    
    //MARK: - Methods
    /***************************************************************/
    
    private func triangle() {
        let height = ((sqrt(3.0)/2) * bounds.maxX) - (strokeWidth * 2)
        let yOffset = (bounds.maxY - height)/2
        path.move(to: CGPoint(x: bounds.midX, y: yOffset))
        path.addLine(to: CGPoint(x: bounds.maxX - strokeWidth, y: bounds.maxY-yOffset))
        path.addLine(to: CGPoint(x: bounds.minX + strokeWidth, y: bounds.maxY-yOffset))
        path.close()
    }
    
    private func diamond() {
        let height = ((sqrt(3.0)/6) * bounds.maxX) - (strokeWidth)
        let yOffset = bounds.maxY / 2 - height
        path.move(to: CGPoint(x: bounds.midX, y: bounds.minY + yOffset))
        path.addLine(to: CGPoint(x: bounds.maxX - strokeWidth, y: bounds.midY))
        path.addLine(to: CGPoint(x: bounds.midX, y: bounds.maxY - yOffset))
        path.addLine(to: CGPoint(x: bounds.minX + strokeWidth, y: bounds.midY))
        path.close()
    }
    
    private func circle() {
        let radius = ((sqrt(3.0)/4) * bounds.maxX) - (strokeWidth)
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
    }
    
    private func oval() {
        let radius = ((sqrt(3.0)/6.2) * bounds.maxX) - (strokeWidth)
        let center1 = CGPoint(x: bounds.midX - radius, y: bounds.midY)
        let center2 = CGPoint(x: bounds.midX + radius, y: bounds.midY)
        path.addArc(withCenter: center1, radius: radius, startAngle: .pi / 2, endAngle: .pi * 3 / 2, clockwise: true)
        path.addLine(to: CGPoint(x: bounds.midX + radius, y: bounds.midY - radius))
        path.addArc(withCenter: center2, radius: radius, startAngle: .pi * 3 / 2, endAngle: .pi / 2, clockwise: true)
        path.close()
    }
    
    private func wave() {
        let radius = ((sqrt(3.0)/4) * bounds.maxX) - (strokeWidth)
        let controlPoint1 = CGPoint(x: bounds.midX / 7, y: bounds.midY / 2.2)
        let controlPoint2 = CGPoint(x: bounds.midX * 1.3, y: bounds.midY / 1.15)
        let controlPoint3 = CGPoint(x: bounds.midX * 1.9, y: bounds.midY / 5)
        let controlPoint4 = CGPoint(x: bounds.maxX - bounds.midX / 7, y: bounds.maxY - bounds.midY / 2.2)
        let controlPoint5 = CGPoint(x: bounds.maxX - bounds.midX * 1.3, y: bounds.maxY - bounds.midY / 1.15)
        let controlPoint6 = CGPoint(x: bounds.maxX - bounds.midX * 1.9, y: bounds.maxY - bounds.midY / 5)
        path.move(to: CGPoint(x: bounds.minX + strokeWidth, y: bounds.midY))
        path.addQuadCurve(to: CGPoint(x: bounds.midX, y: bounds.midY - radius / 3), controlPoint: controlPoint1)
        path.addQuadCurve(to: CGPoint(x: bounds.midX + radius / 1.5, y: bounds.midY - radius / 2), controlPoint: controlPoint2)
        path.addQuadCurve(to: CGPoint(x: bounds.maxX - strokeWidth, y: bounds.midY), controlPoint: controlPoint3)
        path.addQuadCurve(to: CGPoint(x: bounds.midX, y: bounds.midY + radius / 3), controlPoint: controlPoint4)
        path.addQuadCurve(to: CGPoint(x: bounds.midX - radius / 1.5, y: bounds.midY + radius / 2), controlPoint: controlPoint5)
        path.addQuadCurve(to: CGPoint(x: bounds.minX + strokeWidth, y: bounds.midY), controlPoint: controlPoint6)
        path.close()
        path.lineWidth = strokeWidth
    }
    
    private func stripeFill() {
        let stripe = UIBezierPath()
        for x in stride(from: bounds.minX, to: bounds.maxX, by: bounds.maxX/10) {
            stripe.move(to: CGPoint(x: x, y: bounds.minY))
            stripe.addLine(to: CGPoint(x: x, y: bounds.maxY))
        }
        stripe.lineWidth = strokeWidth / 3
        stripe.stroke()
    }
    
    private func configureSymbol() {
        path.lineWidth = strokeWidth
        let symbolColor = symbolColors[colorIndex]
        symbolColor.setStroke()
        path.stroke()
        path.addClip()
        switch symbolFill {
        case 1:
            stripeFill()
        case 2:
            symbolColor.setFill()
            path.fill()
        default:
            break
        }
    }
    
    
    //MARK: - Overrides
    /***************************************************************/
    
    override func draw(_ rect: CGRect) {
        switch symbol {
        case 0:
            diamond()
        case 1:
            oval()
        case 2:
            wave()
        default: break
        }
        configureSymbol()
    }
    
    
}
