//
//  CardViewController.swift
//  CardMatchingGame
//
//  Created by Webb, Terry on 6/7/22.
//

import UIKit

class CardViewController: UIViewController {
    
    var frontShowing: Bool = false
    var frontCardImageView: UIImageView
    var backCardView: UIView
    
    private let cardWidth = 200
    private let cardHeight = 200
    
    init(frontCardImageView: UIImageView, backCardView: UIView){
        self.frontCardImageView = frontCardImageView
        self.backCardView = backCardView
        
        super.init(nibName: nil, bundle: nil)
        
        //other setup methods here
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontShowing ? self.view.addSubview(frontCardImageView) : self.view.addSubview(backCardView)
    
    }
}

