//
//  RecipeTableViewCell.swift
//  Recipes
//
//  Created by Hamoud Alhoqbani on 3/20/18.
//  Copyright © 2018 Hamoud Alhoqbani. All rights reserved.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {
    
    var recipe: Recipe! {
        didSet {
            recipeImageView?.image = recipe.thumbnailImage as? UIImage
            nameLabel.text = recipe.name
            overviewLabel.text = recipe.overview
            prepTimeLabel.text = recipe.prepTime
        }
    }
    
    var recipeImageView: UIImageView!
    var nameLabel: UILabel!
    var overviewLabel: UILabel!
    var prepTimeLabel: UILabel!
    
    // MARK: Frames
    
    var imageSize = CGFloat(42)
    var editingInset = CGFloat(10)
    var textLeftMargin = CGFloat(8.0)
    var textRightMargin = CGFloat(5.0)
    var prepTimeWidth = CGFloat(80.0)
    
    // Returns the frame of the various subviews -- these are dependent on the editing state of the cell.
    var imageViewFrame: CGRect {
        if self.isEditing {
            return CGRect(x: editingInset, y: 0.0, width: imageSize, height: imageSize)
        }
        else {
            return CGRect(x: 0.0, y: 0.0, width: imageSize, height: imageSize)
        }
    }
    
    var nameLabelFrame: CGRect {
        if self.isEditing {
            return CGRect(x: imageSize + editingInset + textLeftMargin, y: 4.0, width: contentView.bounds.size.width - imageSize - editingInset - textLeftMargin, height: 16)
        }
        else {
            return CGRect(x: imageSize + textLeftMargin, y: 4.0, width: contentView.bounds.size.width - imageSize - textRightMargin * 2 - prepTimeWidth, height: 16)
        }
    }
    
    var overviewLabelFrame: CGRect {
        if self.isEditing {
            return CGRect(x: imageSize + editingInset + textLeftMargin, y: 22.0, width: contentView.bounds.size.width - imageSize - editingInset - textLeftMargin, height: 16.0)
        } else {
            return CGRect(x: imageSize + textLeftMargin, y: 22.0, width: contentView.bounds.size.width - imageSize - textLeftMargin, height: 16.0)
        }
    }
    
    var prepTimeLabelFrame: CGRect {
         return CGRect(x: contentView.bounds.size.width - prepTimeWidth - textRightMargin, y: 4, width: prepTimeWidth, height: 16.0)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        recipeImageView = UIImageView(frame: imageViewFrame)
        recipeImageView.contentMode = .scaleAspectFit
        contentView.addSubview(recipeImageView)
        
        overviewLabel = UILabel(frame: overviewLabelFrame)
        overviewLabel.font = UIFont.systemFont(ofSize: 12)
        overviewLabel.textColor = .darkGray
        overviewLabel.highlightedTextColor = .white
        contentView.addSubview(overviewLabel)
        
        prepTimeLabel = UILabel(frame: prepTimeLabelFrame)
        prepTimeLabel.textAlignment = .right
        prepTimeLabel.font = UIFont.systemFont(ofSize: 12)
        prepTimeLabel.textColor = .black
        prepTimeLabel.highlightedTextColor = .white
        prepTimeLabel.minimumScaleFactor = 7.0
        prepTimeLabel.lineBreakMode = .byTruncatingTail
        contentView.addSubview(prepTimeLabel)

        nameLabel = UILabel(frame: nameLabelFrame)
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        nameLabel.textColor = .black
        nameLabel.highlightedTextColor = .white
        contentView.addSubview(nameLabel)
    }
    
    // To save space, the prep time label disappears during editing.
    override func layoutSubviews() {
        super.layoutSubviews()
        
        recipeImageView.frame = imageViewFrame
        nameLabel.frame = nameLabelFrame
        overviewLabel.frame = overviewLabelFrame
        prepTimeLabel.frame = prepTimeLabelFrame
        
        if isEditing {
            prepTimeLabel.alpha = 0
        } else {
            prepTimeLabel.alpha = 1
        }
    }

}
