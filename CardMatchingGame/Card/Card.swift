//
//  Card.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/7/22.
//

import Foundation

class Card: PlayingCard {
    
    typealias Face = CardFace
    
    var faceValue: Face
    var isFlipped = false
    var isMatched = false
    
    init(face: Face){
        self.faceValue = face
    }
}
