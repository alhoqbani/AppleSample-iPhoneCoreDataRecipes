//
//  EditingTableViewCell.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/20/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class EditingTableViewCell: UITableViewCell {
    
    static let identifier = "IngredientsCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
