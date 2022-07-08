//
//  CardViewable.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/8/22.
//

import Foundation
import UIKit

protocol CardViewable {
    var card: Card? { get }
    var backView: UIView { get set }
    var frontView: UILabel { get set }
    
    func flipCard(withDelay: Bool)
    func setCard(card: Card)
    func disableCard()
    func enableCard()
    func setMatchedState()
}
