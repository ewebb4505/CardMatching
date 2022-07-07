//
//  TotalGameDataView.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/1/22.
//

import UIKit

@IBDesignable class TotalGameDataViewWrapper : NIBWrapperView<TotalGameDataView> { }

class TotalGameDataView: UIView {

    @IBOutlet weak var dataImage: UIImageView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataTypeLabel: UILabel!
    
    var label : String = "" {
        didSet {
            dataTypeLabel.text = label
            
        }
    }
    
    var data: String = ""{
        didSet {
            dataLabel.text = data
            
        }
    }
        
    var symbol : String = "" {
        didSet {
            let img = UIImage(systemName: symbol)?.withRenderingMode(.alwaysOriginal)
            
            dataImage.image = img
            
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
