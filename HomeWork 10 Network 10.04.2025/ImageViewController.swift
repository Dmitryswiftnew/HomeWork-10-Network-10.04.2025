
import UIKit



class ImageViewController: UIViewController {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var factLabel: UILabel!
    
    
    
    
    override func viewDidLoad() {
        navigationController?.navigationBar.tintColor = .systemOrange // Цвет кнопок
        navigationController?.navigationBar.barTintColor = .systemBackground // Фон
        title = "Случайный кот"
        setupRefreshButton()
        activityIndicator.startAnimating()
        loadRandomContent()
    }
    
    private func setupRefreshButton() {
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh, // иконка обновить
            target: self, // Объект, который обработает нажатие
            action: #selector(refreshButtonTapped) // метод который вызовется
            
        )
        navigationItem.rightBarButtonItem = refreshButton // размещаем справа
        
        
    }
    
    @objc private func refreshButtonTapped() {
        activityIndicator.stopAnimating()
        loadRandomContent()
        
        
        
        
    }
    
    private func loadRandomContent() {
        // Создаем группу для параллельных запросов
        
        let group = DispatchGroup()
        var catImage: CatImage?
        var catFact: String?
        var lastError: Error?
        
        // загрузка изображения
        
        group.enter()
        NetworkService.shared.fetchRandomCat { result in
            switch result {
            case .success(let image):
                catImage = image
            case .failure(let error):
                lastError = error
            }
            group.leave()
        }
        
        // загрузка факта
        group.enter()
        NetworkService.shared.fetchRandomCatFact { result in
            switch result {
            case .success(let fact):
                catFact = fact
            case .failure(let error):
                lastError = error
            }
            
            group.leave()
        }
        
        // обновляем UI после всех запросов
        
        group.notify(queue: .main) { [weak self] in
            self?.activityIndicator.stopAnimating()
            
            if let error = lastError {
                self?.showErrorAlert(error: error)
                return
            }
            
            // устанавливаем изображение
            if let imageUrl = catImage?.url {
                self?.catImageView.loadImage(from: imageUrl)
            } else {
                self?.catImageView.image = UIImage(systemName: "photo.on.rectangle")
            }
            
            
            // устанавливаем факт
            self?.factLabel.text = catFact ?? "Факт не найден"
        }
    }
    
    private func showErrorAlert(error: Error) {
        let alert = UIAlertController(
            title: "Ошибка",
    message: error.localizedDescription,
    preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        alert.addAction(UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
        })
        
        present(alert, animated: true)
    }
    
    
    
//    private func loadRandomContent() {
//        NetworkService.shared.fetchRandomCat { [weak self] (result: Result<CatImage, Error>) in // Явно указываем тип
//            DispatchQueue.main.async {
//                self?.activityIndicator.stopAnimating()
//
//                switch result {
//                case .success(let cat):
//                    self?.catImageView.loadImage(from: cat.url)
//                case .failure(let error):
//                    print("Ошибка: \(error.localizedDescription)")
//                    // Можно показать UIAlertController с ошибкой
//                }
//            }
//        }
//    }
 
}

extension UIImageView {
    func loadImage(from urlString: String) {
        // проверяем кэш
        if let cacheImage = ImageCache.shared.get(forKey: urlString) {
            self.image = cacheImage
            return
        }
        
        
        guard let url = URL(string: urlString) else {
            self.image = UIImage(systemName: "photo.on.rectangle")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                // сохраняем в кэш
                ImageCache.shared.set(image, forKey: urlString)
                
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        } .resume()
    }
}
