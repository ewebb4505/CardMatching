//
//  PreviousGameTableViewCell.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/3/22.
//

import UIKit

class PreviousGameTableViewCell: UITableViewCell {

    @IBOutlet weak var tapsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    public static let reusableID: String = "gameHistTableCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
