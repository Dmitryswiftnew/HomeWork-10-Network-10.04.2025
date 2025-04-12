//
//  CatTableViewCell.swift
//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 10.04.25.
//

import UIKit

class CatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var breedLabel: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
