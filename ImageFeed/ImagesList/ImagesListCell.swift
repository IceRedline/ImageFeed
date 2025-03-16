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
    
    // MARK: - Configure cell
    func configure(with photo: Photo, dateFormatter: ((Date?) -> String)?) {
        cellImage.kf.indicatorType = .activity
        cellImage.image = UIImage.cardStub // Сбрасываем старое изображение
        
        let imageURL = URL(string: photo.thumbImageURL)
        cellImage.kf.setImage(with: imageURL, placeholder: UIImage.cardStub) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                break // обновляется картинка без релоада
            case .failure:
                self.cellImage.image = UIImage.cardStub
                
            }
        }
        
        dateLabel.text = dateFormatter?(photo.createdAt)
        setIsLiked(photo.isLiked)
    }
}
