//
//  CardCollectionViewCell.swift

//  CardMatchingGame
//
//  Created by Webb, Terry on 6/8/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell, CardViewable {

    var card: Card?
    
    var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    var frontView: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    //this is for registereing the collection view cell to the UICollectionView object in the parent view controller. 
    public static var reusableID: String = "cellID"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        
        //set up the frames of the frontView and backView to be the same size as the contentView
        self.frontView.frame = self.contentView.frame
        self.backView.frame = self.contentView.frame
        
        //add the backView as a subview to the contentView first since cards should be faced down at the start of the game
        self.contentView.addSubview(self.backView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        self.backgroundColor = .systemGray5
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
    }
    
    public func getCard() -> Card {
        if let card = self.card {
            return card
        } else {
            fatalError("getCard called but card is not setup!")
        }
    }
    
    public func setCard(card: Card) -> Void {
        self.card = card
        self.frontView.text = self.card?.faceValue.getImageNameFromCardName()
    }
    
    public func disableCard() {
        self.isUserInteractionEnabled = false
    }
    
    public func enableCard() {
        self.isUserInteractionEnabled = true
    }
    
    public func flipCard(withDelay: Bool) {
        guard let card = card else {
            fatalError("Trying to flip a card that is not set")
        }
        
        card.isFlipped = !card.isFlipped
        if withDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                self.flipCard(card: card)
            }
        } else {
            self.flipCard(card: card)
        }
    }
    
    private func flipCard(card: Card) {
        card.isFlipped ? flipCardBackToFront() : flipCardFrontToBack()
    }
    
    private func flipCardBackToFront() {
        UIView.transition(from: self.contentView,
                          to: self.frontView,
                          duration: 0.5,
                          options: .transitionFlipFromRight,
                          completion: nil)
    }
    
    private func flipCardFrontToBack() {
        UIView.transition(from: self.frontView,
                          to: self.contentView,
                          duration: 0.5,
                          options: .transitionFlipFromRight,
                          completion: nil)
    }
    
    public func resetCard() {
        guard let card = card else { fatalError("Tring to resetCard when the card is not set") }
        
        if card.isFlipped {
            card.isFlipped = false
            card.isMatched = false
            //since I'm transitioning here, that is why the next transition doesn't work because its the back
            flipCardFrontToBack()
            resetMatchedCardStyle()
        }
        
    }
    
    public func setMatchedState() {
        self.changeToMatchedCard()
    }
    
    private func changeToMatchedCard() -> Void {
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .transitionCrossDissolve, animations: {
            self.backgroundColor = .systemGreen.withAlphaComponent(0.15)
            self.layer.borderColor = UIColor.systemGreen.cgColor
        }, completion: nil)
    }
    
    public func resetMatchedCardStyle() -> Void {
        UIView.animate(withDuration: 0.2, delay: 0.4, options: .transitionCrossDissolve, animations: {
            self.backgroundColor = .systemGray5
            self.layer.borderColor = UIColor.black.cgColor
        }, completion: nil)
    }
}

