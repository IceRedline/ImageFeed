//
//  ViewController.swift
//  ImageFeed
//
//  Created by Артем Табенский on 22.12.2024.
//

import UIKit

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    @IBOutlet private var tableView: UITableView!
    
    private let showSingleImageSegueID = "ShowSingleImage"
    var presenter: ImagesListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(ImagesListPresenter())
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.accessibilityIdentifier = AccessibilityIDs.imageList
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        presenter?.viewDidLoad()
    }
    
    func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.view = self
    }
    
    func updateTableViewAnimated() {
        guard let presenter = presenter else { return }
        let oldCount = tableView.numberOfRows(inSection: 0)
        let newCount = presenter.getPhotosCount()
        
        guard oldCount != newCount else { return }
        
        let newIndices = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
        tableView.performBatchUpdates {
            tableView.insertRows(at: newIndices, with: .automatic)
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            
            let photo = presenter?.getPhoto(at: indexPath)
            viewController.imageURL = URL(string: photo?.fullImagevarURL ?? "")
        }
    }
}

// MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.getPhotosCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ImagesListCell.reuseIDentifier,
            for: indexPath
        ) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        if let photo = presenter?.getPhoto(at: indexPath) {
            cell.configure(with: photo, dateFormatter: presenter?.getFormattedDate(from:))
        }
        cell.delegate = self
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: showSingleImageSegueID, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let photo = presenter?.getPhoto(at: indexPath) else { return 0 }
        let imageWidth = photo.size.width
        let imageHeight = photo.size.height
        let tableWidth = tableView.bounds.width
        return (imageHeight / imageWidth) * tableWidth
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if ProcessInfo.processInfo.arguments.contains("UITests") {
            return
        }
        
        if indexPath.row == (presenter?.getPhotosCount() ?? 0) - 1 {
            presenter?.fetchPhotosNextPage()
        }
    }
}

// MARK: - ImagesListCellDelegate

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = presenter?.getPhoto(at: indexPath)
        
        presenter?.changeLike(photoId: photo?.id ?? "", isLiked: photo?.isLiked ?? false) { success in
            if success {
                cell.setIsLiked(!(photo?.isLiked ?? false))
            }
        }
    }
}
