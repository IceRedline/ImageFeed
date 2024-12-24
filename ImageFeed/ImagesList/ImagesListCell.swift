//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.12.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Static properties
    
    static let reuseIDentifier = "ImagesListCell"

}
