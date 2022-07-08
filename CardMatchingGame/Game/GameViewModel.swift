//
//  GameModel.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/10/22.
//

import Foundation


class GameViewModel<CardView: CardViewable> {
    
    private var selectedPair: (first: CardView?, second: CardView?)
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
    
    public func setFirstCardInSelectedPair(_ card: CardView){
        if selectedPair.first != nil {
            fatalError("there is already a first selection, setFirstCardInSelectedPair should not have been called")
        } else {
            selectedPair.first = card
        }
    }
    
    public func setSecondCardInSelectedPair(_ card: CardView){
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
        
        guard let firstCard = first.card else {
            fatalError("Trying to check selected pair for a match with the first selected card being nil.")
        }
        
        guard let secondCard = second.card else {
            fatalError("Trying to check selected pair for a match with the second selected card being nil.")
        }
        
        if  firstCard.faceValue.getImageNameFromCardName() == secondCard.faceValue.getImageNameFromCardName(){
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
        guard let first = selectedPair.first else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        
        guard let second = selectedPair.second else {
            fatalError("Trying to set cards to matched but second selection is not set")
        }
        
        guard let firstCard = first.card else {
            fatalError("Trying to set first card selection to matched with it being nil.")
        }
        
        guard let secondCard = second.card else {
            fatalError("Trying to set second card selection to matched with it being nil.")
        }
        
        firstCard.isMatched = true
        secondCard.isMatched = true
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
    
    public func flipFirstCardSelected(withDelay: Bool) {
        guard let first = selectedPair.first else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        first.flipCard(withDelay: withDelay)
    }
    
    public func flipSecondCardSelected(withDelay: Bool) {
        guard let second = selectedPair.second else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        second.flipCard(withDelay: withDelay)
    }
    
    public func disableFirstCardSelection() {
        guard let first = selectedPair.first else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        first.disableCard()
    }
    
    public func disableSecondCardSelection() {
        guard let second = selectedPair.second else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        second.disableCard()
    }
    
    public func enableFirstCardSelection() {
        guard let first = selectedPair.first else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        first.enableCard()
    }
    
    public func enableSecondCardSelection() {
        guard let second = selectedPair.second else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        second.enableCard()
    }
    
    public func setCardSelectionToMatchedState() {
        guard let first = selectedPair.first, let second = selectedPair.second else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        guard let firstCard = first.card, let secondCard = second.card else {
            fatalError("Trying to set cards to matched but first selection is not set")
        }
        
        if firstCard.isMatched && secondCard.isMatched {
            first.setMatchedState()
            second.setMatchedState()
        } else {
            print("Why were both cards not in matched state before needing to set the cards matched view state?")
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
