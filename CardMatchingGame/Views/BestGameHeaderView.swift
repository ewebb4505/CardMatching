//
//  BestGameHeaderView.swift
//  CardMatchingGame
//
//  Created by Evan Webb on 7/2/22.
//

import UIKit

class BestGameHeaderView: UITableViewHeaderFooterView {

    let title = UILabel()
    
    public static let reusableID: String = "bestGameHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.font = UIFont(name: "Fredoka-Medium", size: 17)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
