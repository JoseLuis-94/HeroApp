//
//  TableViewCell.swift
//  HeroApp
//
//  Created by Graciela Sarahi Guerra Castillo on 18/02/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
