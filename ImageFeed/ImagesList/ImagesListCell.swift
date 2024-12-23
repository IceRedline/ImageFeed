//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.12.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    static let reuseIDentifier = "ImagesListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
