//

//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 11.04.25.
//

import Foundation
import Alamofire

final class NetworkService {
    static let shared = NetworkService() // делаем Singleton
    private init() {}
    
    
    // Загрузка 1 случайного кота
    
//    func fetchRandomCat(completion: @escaping (Result<CatImage, Error>) -> Void) {
//        let url = URL(string: "https://api.thecatapi.com/v1/images/search")!
//
//        URLSession.shared.dataTask(with: url) { data, _, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            do {
//                let cats = try JSONDecoder().decode([CatImage].self, from: data!)
//                guard let firstCat = cats.first else {
//                    let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No cats found"])
//                    completion(.failure(error))
//                    return
//                }
//                completion(.success(firstCat))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
    
    // Alamofire
    
    func fetchRandomCat(completion: @escaping (Result<CatImage, AFError>) -> Void) {
        // 1. используем AF.request вместо URLSession
        AF.request("https://api.thecatapi.com/v1/images/search")
        // 2. автоматическая валидация статус-кодов 200..<300
            .validate()
        // 3. парсим JSON прямо в модель [CatImage]
            .responseDecodable(of: [CatImage].self) { response in
                switch response.result {
                case .success(let cats):
                    // 4. извлекаем первого кота
                    guard let firstCat = cats.first else {
                        completion(.failure(AFError.explicitlyCancelled))
                        return
                    }
                    completion(.success(firstCat))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    
    // Alamofire - короткий синтаксис
    
//    func fetchRandomCat(completion: @escaping (Result<CatImage, AFError>) -> Void) {
//        AF.request("https://api.thecatapi.com/v1/images/search")
//            .validate()
//            .responseDecodable(of: [CatImage].self) { response in
//                completion(response.result.flatMap { cats in
//                    cats.first.map { .success($0) } ?? .failure(.explicitlyCancelled)
//                })
//            }
//    }

    
    
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
//        func fetchRandomCatFact(completion: @escaping (Result<String, Error>) -> Void) {
//            let url = URL(string: "https://catfact.ninja/fact")!
//
//            URLSession.shared.dataTask(with: url) { data, _, error in
//                if let error = error {
//                    completion(.failure(error))
//                    return
//                }
//
//                do {
//                    let fact = try JSONDecoder().decode([String: String].self, from: data!)
//                    guard let factText = fact["fact"] else {
//                        throw NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Fact not found"])
//                    }
//                    completion(.success(factText))
//                } catch {
//                    completion(.failure(error))
//                }
//            }.resume()
//        }
    
    func fetchRandomCatFact(completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "https://catfact.ninja/fact")!
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            do {
                let factResponse = try JSONDecoder().decode(CatFact.self, from: data!) // Используем CatFact
                completion(.success(factResponse.fact))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    }
    
    
    

