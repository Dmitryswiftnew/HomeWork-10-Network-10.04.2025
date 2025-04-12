
import UIKit



class ImageViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var factLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        activityIndicator.startAnimating()
        loadRandomContent()
    }
    
    private func loadRandomContent() {
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
