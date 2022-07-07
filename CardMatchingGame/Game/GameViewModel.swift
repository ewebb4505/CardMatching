//
//  GameModel.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/10/22.
//

import Foundation


class GameViewModel {
    
    private var selectedPair: (first: Card?, second: Card?)
    private var totalTime: Double?
    //private var totalTimeFirstCardCanBeOpen: Double = 5
    private var numberOfMatches: Int = 0
    private var cards: [Card]
    private var gameComplete = false
    private var didUserCompleteGame = false
    private var didUserEndGame = false
    private var numberOfTaps = 0
    
    init(cards: [Card]){
        self.cards = cards
    }
    
    public func setFirstCardInSelectedPair(_ card: Card){
        if selectedPair.first != nil {
            fatalError("there is already a first selection, setFirstCardInSelectedPair should not have been called")
        } else {
            selectedPair.first = card
        }
    }
    
    public func setSecondCardInSelectedPair(_ card: Card){
        if selectedPair.second != nil {
            fatalError("there is already a second selection, setSecondCardInSelectedPair should not have been called")
        } else {
            selectedPair.second = card
        }
    }
    
    
    public func checkSelectedPairForMatch() -> Bool {
        guard let first = selectedPair.first else {
            return false
        }
        
        guard let second = selectedPair.second else {
            return false
        }
        
        if first.imageName.getImageNameFromCardName() == second.imageName.getImageNameFromCardName(){
            return true
        } else {
            return false
        }
    }
    
    public func isFirstSelectionEmpty() -> Bool {
        return selectedPair.first == nil ? true : false
    }
    
    public func isSecondSelectionEmpty() -> Bool {
        return selectedPair.second == nil ? true : false
    }
    
    public func setCardMatchPropForSelectedCards() {
        if let first = selectedPair.first {
            first.isMatched = true
        } else {
            fatalError("trying to say that the first selection nil card is matched? WRONG")
        }
        
        if let second = selectedPair.second {
            second.isMatched = true
        } else {
            fatalError("trying to say that the second selection nil card is matched? WRONG")
        }
    }
    
    public func resetCardSelection() {
        self.selectedPair.first = nil
        self.selectedPair.second = nil
    }
    
    public func isGameComplete() -> Bool {
        var isComplete = true
        for card in self.cards {
            if !card.isMatched {
                isComplete = false
            }
        }
        return isComplete
    }
    
    public func resetCards() {
        for card in self.cards {
            card.isFlipped = false
            card.isMatched = false
        }
    }
    
    public func getNumberOfCards() -> Int {
        return self.cards.count
    }
    
    public func getCards() -> [Card] {
        return self.cards
    }
    
    public func resetGame() {
        self.resetCardSelection()
        self.gameComplete = false
        self.didUserCompleteGame = false
        self.numberOfTaps = 0
        
        for card in cards {
            card.isFlipped = false
            card.isMatched = false
        }
    }
    
    public func shuffleCards() {
        self.cards.shuffle()
    }
    
    public func setUserDidEndGame(_ bool: Bool) {
        self.didUserCompleteGame = bool
    }
    public func getUserDidEndGame() -> Bool {
        return self.didUserEndGame
    }
}
