//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 22.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private var imagesListServiceObserver: NSObjectProtocol?
    private let imagesListService = ImagesListService()
    
    var photos: [Photo] = []
    private let currentDate = Date()
    private let showSingleImageSegueID = "ShowSingleImage"
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    // MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addObserverToFetchNewPage()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        imagesListService.fetchPhotosNextPage()
    }
    
    // MARK: - Methods
    
    private func addObserverToFetchNewPage() {
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
    }
    
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.cellImage.kf.indicatorType = .activity
        cell.cellImage.image = UIImage.cardStub // Сбрасываем старое изображение
        
        let photo = photos[indexPath.row]
        let imageURL = URL(string: photo.thumbImageURL)
        
        let currentIndexPath = indexPath
        
        cell.cellImage.kf.setImage(with: imageURL, placeholder: UIImage.cardStub) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                // Проверяем, что ячейка все еще отображает нужное фото
                if let updatedIndexPath = self.tableView.indexPath(for: cell), updatedIndexPath == currentIndexPath {
                    switch result {
                    case .success:
                        break // обновляется картинка без релоада
                    case .failure:
                        cell.cellImage.image = UIImage.cardStub
                    }
                }
            }
        }
        
        if let date = photo.createdAt {
            cell.dateLabel.text = dateFormatter.string(from: date)
        } else {
            cell.dateLabel.text = ""
        }
        
        let buttonImageName = photo.isLiked ? "favorite_active" : "favorite_inactive"
        cell.likeButton.setImage(UIImage(named: buttonImageName), for: .normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueID {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            viewController.imageURL = URL(string: photos[indexPath.row].fullImagevarURL)
            
        } else {
            prepare(for: segue, sender: sender)
        }
    }
    
}

// MARK: - Extensions

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let imageListCell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIDentifier,
            for: indexPath
        ) as? ImagesListCell else {
            print("Ошибка: загружена дефолтная ячейка")
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        imageListCell.delegate = self
        return imageListCell
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueID, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageWidth = photos[indexPath.row].size.width
        let imageHeight = photos[indexPath.row].size.height
        let tableWidth = tableView.bounds.width
        return (imageHeight / imageWidth) * tableWidth
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newPhotos = imagesListService.photos // берем обновленные данные
        
        guard oldCount != newPhotos.count else { return }
        
        let newIndices = (oldCount..<newPhotos.count).map { IndexPath(row: $0, section: 0) }
        
        photos = newPhotos // обновляем массив перед анимацией
        tableView.performBatchUpdates {
            tableView.insertRows(at: newIndices, with: .automatic)
        }
    }
}

extension ImagesListViewController {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == photos.count - 1 { // проверяем, если ячейка последняя - подгружаем новые данные
            imagesListService.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLiked: photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                // Синхронизируем массив картинок с сервисом
                self.photos = self.imagesListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                let alert = UIAlertController(title: "Произошла ошибка", message: "Что-то пошло не так", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
