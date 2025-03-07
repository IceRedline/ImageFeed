//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 12.01.2025.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var imageURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        
        loadImage()
    }
    
    // MARK: - Methods
    
    private func loadImage() {
        if let imageURL {
            imageView.kf.indicatorType = .activity // вместо ProgressHUD 
            imageView.kf.setImage(with: imageURL) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let value):
                    self.imageView.image = value.image
                    self.imageView.frame.size = value.image.size
                    self.rescaleAndCenterImageInScrollView(image: value.image)
                case .failure(let error):
                    self.showError()
                    print("Ошибка загрузки изображения: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(hScale, vScale)
        
        scrollView.minimumZoomScale = scale
        scrollView.setZoomScale(scale, animated: false)
        
        DispatchQueue.main.async {
            let newContentSize = self.scrollView.contentSize
            let offsetX = max((self.scrollView.bounds.width - newContentSize.width) * 0.5, 0.0)
            let offsetY = max((self.scrollView.bounds.height - newContentSize.height) * 0.5, 0.0)
            
            self.scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX)
        }
    }
    
    
    @IBAction private func shareButtonTapped() {
        guard let image = imageView.image else { return }
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    @IBAction private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Произошла ошибка", message: "Что-то пошло не так. Попробовать ещё раз?", preferredStyle: .alert)
        let actionRetry = UIAlertAction(title: "Повторить", style: .default) { _ in
            self.loadImage()
        }
        let actionDiscard = UIAlertAction(title: "Не надо", style: .cancel) { _ in
            self.backButtonTapped()
        }
        alert.addAction(actionRetry)
        alert.addAction(actionDiscard)
        present(alert, animated: true)
    }
}

// MARK: - Extensions

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        scrollView.contentInset = UIEdgeInsets(top: offsetY, left: offsetX, bottom: offsetY, right: offsetX);
    }
}
