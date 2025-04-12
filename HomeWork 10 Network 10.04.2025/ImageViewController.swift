//
//  ImageViewController.swift
//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 10.04.25.
//
import UIKit



class ImageViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var factLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        loadRandomCat()
    }
    
    private func loadRandomCat() {
        NetworkService.shared.fetchRandomCat { [weak self] (result: Result<CatImage, Error>) in // Явно указываем тип
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                
                switch result {
                case .success(let cat):
                    self?.catImageView.loadImage(from: cat.url)
                case .failure(let error):
                    print("Ошибка: \(error.localizedDescription)")
                    // Можно показать UIAlertController с ошибкой
                }
            }
        }
    }
 
}
