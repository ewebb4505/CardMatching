//
//  PreviousGameHeaderView.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/1/22.
//

import UIKit

class PreviousGameHeaderView: UITableViewHeaderFooterView {

    let title = UILabel()
    let subtitle = UILabel()
    let image = UIImageView()
    
    public static let reusableID: String = "previousGamesHeader"

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        
        title.font = UIFont(name: "Fredoka-Medium", size: 17)
        subtitle.font = UIFont(name: "Fredoka-Regular", size: 14)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(subtitle)

        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            
            subtitle.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            subtitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            subtitle.heightAnchor.constraint(equalToConstant: 30),
            
            image.trailingAnchor.constraint(equalTo: subtitle.layoutMarginsGuide.leadingAnchor, constant: -8),
            image.widthAnchor.constraint(equalToConstant: 20),
            image.heightAnchor.constraint(equalToConstant: 20),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
