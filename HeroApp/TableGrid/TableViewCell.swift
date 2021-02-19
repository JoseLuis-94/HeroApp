//
//  TableViewCell.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 17/02/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setupUI()
    }
    
    // MARK: - Properties
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        //label.font = UIFont(name: "HelveticaNeue", size: 20)
        //label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
}

// MARK: - UI Setup
extension TableViewCell {
    private func setupUI() {
        self.contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
    }
}
