//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 12.01.2025.
//

import UIKit

class SingleImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }

    @IBAction func backButtonTapped() {
        dismiss(animated: true)
    }
}
