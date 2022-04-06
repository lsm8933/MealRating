//
//  MealTableViewCell.swift
//  MealRating
//
//  Created by Jing Li on 8/4/21.
//

import UIKit

class MealTableViewCell: UITableViewCell {
    // MARK: Properties
    @IBOutlet weak var dishImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
