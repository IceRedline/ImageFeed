//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Артем Табенский on 23.12.2024.
//

import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    
    // MARK: - @IBOutlet properties
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Static properties
    
    static let reuseIDentifier = "ImagesListCell"
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - prepare for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ liked: Bool) {
        likeButton.setImage(liked ? UIImage.favoriteActive : UIImage.favoriteInactive, for: .normal)
    }
    
}
