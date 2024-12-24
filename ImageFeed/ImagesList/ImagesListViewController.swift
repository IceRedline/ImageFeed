//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 22.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosNamesArray = Array(0..<20).map{ "\($0)" }
    private let currentDate = Date()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let image = UIImage(named: photosNamesArray[indexPath.row])
        cell.cellImage.image = image
        
        cell.dateLabel.text = dateFormatter.string(from: currentDate)
        
        let buttonImageName = indexPath.row % 2 == 0 ? "Active" : "No Active"
        cell.likeButton.setImage(UIImage(named: buttonImageName), for: .normal)
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosNamesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIDentifier,
            for: indexPath
        ) as? ImagesListCell else {
            print("Ошибка: загружена дефолтная ячейка")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath) // 3
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosNamesArray[indexPath.row]) else { return 200 }
        let imageWidth = image.size.width
        let imageHeight = image.size.height
        let tableWidth = tableView.bounds.width
        return (imageHeight / imageWidth) * tableWidth
    }
}
