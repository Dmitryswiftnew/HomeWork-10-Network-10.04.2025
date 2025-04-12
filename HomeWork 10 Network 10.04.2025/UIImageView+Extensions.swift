//
//  UIImageView+Extensions.swift
//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 11.04.25.
//

import UIKit

extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder ?? UIImage(systemName: "photo")
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            if let error = error {
                print("Ошибка загрузки: \(error.localizedDescription)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.image = image
                }
            }
        }.resume()
    }
}
