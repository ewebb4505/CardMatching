//
//  PlayingCard.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/8/22.
//

import Foundation

protocol PlayingCard {
    associatedtype Face
    var isFlipped: Bool { get set }
    var isMatched: Bool { get set }
}
