//
//  Card.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/7/22.
//

import Foundation

class Card {
    var imageName: CardName
    var isFlipped = false
    var isMatched = false
    
    init(imageName: CardName){
        self.imageName = imageName
    }
}
