//
//  CardModel.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/7/22.
//

import Foundation

class CardModel {
    
    private var cardNames: [CardFace] = CardFace.allCases
    private var numOfCards: Int = CardFace.allCases.count
    private var numOfCardsForDemo: Int = 4
    
    public func getCards(shuffleCards: Bool) -> [Card] {
        var cardArr: [Card] = []

        for cardName in 0..<numOfCards {
            let newCard1: Card = Card(face: cardNames[cardName])
            let newCard2: Card = Card(face: cardNames[cardName])
            
            cardArr.append(newCard1)
            cardArr.append(newCard2)
        }
        print(cardArr.count)
        if shuffleCards { cardArr.shuffle() }
        return cardArr
    }
    
    public func getCardsForDemo() -> [Card] {
        var cardArr: [Card] = []
        
        let firstNewCard1: Card = Card(face: cardNames[0])
        let firstNewCard2: Card = Card(face: cardNames[0])
        
        cardArr.append(firstNewCard1)
        cardArr.append(firstNewCard2)
        
        let secondNewCard1: Card = Card(face: cardNames[1])
        let secondNewCard2: Card = Card(face: cardNames[1])
        
        cardArr.append(secondNewCard1)
        cardArr.append(secondNewCard2)
        
        return cardArr
    }
    
    public func shuffleCards(cards : inout [Card]) {
        cards.shuffle()
    }
    
    public func getNumOfCards() -> Int {
        return numOfCards
    }
    
    public func getNumOfCardsForDemo() -> Int {
        return numOfCardsForDemo
    }
}
