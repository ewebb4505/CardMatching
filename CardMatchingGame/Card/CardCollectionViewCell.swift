//
//  CardCollectionViewCell.swift

//  CardMatchingGame
//
//  Created by Webb, Terry on 6/8/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    public var card: Card?
    public static var reusableID: String = "cellID"
    
    
    var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    var backView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray5
        self.label.frame = self.contentView.frame
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 2
        
        self.backView = UIView(frame: self.contentView.frame)
        
        self.contentView.addSubview(self.backView!)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.label.text = self.card?.imageName.getImageNameFromCardName()
    }
    
    public func flipCard(withDelay: Bool) {
        guard let card = card else {
            fatalError("Trying to flip a card that is not set")
        }
        card.isFlipped = !card.isFlipped
        //print("isFlipped = \(card.isFlipped)")
        if withDelay {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                if card.isFlipped {
                        UIView.transition(from: self.contentView,
                                          to: self.label,
                                          duration: 0.5,
                                          options: .transitionFlipFromRight,
                                          completion: nil)
                } else {
                        UIView.transition(from: self.label,
                                          to: self.contentView,
                                          duration: 0.5,
                                          options: .transitionFlipFromRight,
                                          completion: nil)
                }
            }
        } else {
            if card.isFlipped {
                    UIView.transition(from: self.contentView,
                                      to: self.label,
                                      duration: 0.5,
                                      options: .transitionFlipFromRight,
                                      completion: nil)
                
            } else {
                    UIView.transition(from: self.label,
                                      to: self.contentView,
                                      duration: 0.5,
                                      options: .transitionFlipFromRight,
                                      completion: nil)
            }
        }
    }
    
    public func resetCard() {
        guard let card = card else { fatalError("Tring to resetCard when the card is not set") }
        
        if card.isFlipped {
            card.isFlipped = false
            card.isMatched = false
            //since I'm transitioning here, that is why the next transition doesn't work because its the back
            UIView.transition(from: self.label,
                              to: self.contentView,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              completion: nil)
            resetMatchedCardStyle()
        }
        
    }
    
    public func changeToMatchedCard() -> Void {
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

