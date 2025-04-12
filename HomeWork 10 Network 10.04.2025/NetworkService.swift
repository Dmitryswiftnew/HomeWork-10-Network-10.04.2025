//

//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 11.04.25.
//

import Foundation

final class NetworkService {
    static let shared = NetworkService() // делаем Singleton
    private init() {}
    
    
    // Загрузка 1 случайного кота
    
    func fetchRandomCat(completion: @escaping (Result<CatImage, Error>) -> Void) {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let cats = try JSONDecoder().decode([CatImage].self, from: data!)
                guard let firstCat = cats.first else {
                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No cats found"])
                    completion(.failure(error))
                    return
                }
                completion(.success(firstCat))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Загрузка 10 котов
    
    func fetchTenCats(completion: @escaping (Result<[CatImage], Error>) -> Void) {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=10")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let cats = try JSONDecoder().decode([CatImage].self, from: data!)
                completion(.success(cats))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
    }
    
    // MARK: - Cat Fact (1 случайный факт)
        func fetchRandomCatFact(completion: @escaping (Result<String, Error>) -> Void) {
            let url = URL(string: "https://catfact.ninja/fact")!
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                do {
                    let fact = try JSONDecoder().decode([String: String].self, from: data!)
                    guard let factText = fact["fact"] else {
                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fact not found"])
                    }
                    completion(.success(factText))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    
    

