//
//  ConcentrationThemeViewController.swift
//  The Game of Set
//
//  Created by Cassidy Caid on 3/12/19.
//  Copyright © 2019 Cassidy Caid. All rights reserved.
//

import UIKit

class ConcentrationThemeViewController: UIViewController, UISplitViewControllerDelegate {
    
    
    private let themeArray = [ //Includes extra credit theme colors
        ("Sports", "⚾️⚽️🏀🏈🏐🎾🎱🥏🏓🏸🏋️‍♀️🛹🏹🏏🏑⛳️🎳🧗‍♀️", #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
        ("Foods", "🍐🍊🍋🍉🍇🍓🍒🍑🍍🥥🥝🍅🍆🥑🥦🥒🌶🌽🥕🥐🥯🥖🥨🧀🍳🥞", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)),
        ("Animals", "🐶🐱🐹🐰🦊🐻🐼🐨🐷🦁🐮🐒🐸🐣🐛🐝🦄🐴🦉🐺🐗🦅🦆🐥🐧🐔🦕🦖", #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)),
        ("Faces", "😍😆🤪🤓🤩🥳😎🥺🤬🤯🥶🥵🤗🤥😑🤢😷🤑", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        ("Vehicles", "🚂🚖🏍🚜🚒🚎🚛🚲🛵🚁🚀⛵️🛩🚇🎠🏍🚠🛶🛸🚤🎢", #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)),
        ("Spooks", "👹🎃👻😈👺🍬🎭💥🧻☠️🌛🚪🙀👽🧛‍♀️⚰️🕸🧟‍♀️🧹", #colorLiteral(red: 0.9450980392, green: 0.6549019608, blue: 0.2039215686, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
        ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func chooseTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let button = sender as? UIButton {
                let theme = themeArray[button.tag - 1]
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToCVC {
            if let button = sender as? UIButton {
                let theme = themeArray[button.tag - 1]
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    // MARK: - Navigation
    
    private var lastSeguedToCVC: ConcentrationViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                let theme = themeArray[button.tag - 1]
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.theme = theme
                    lastSeguedToCVC = cvc
                }
            }
        }
    }
    
    
}
