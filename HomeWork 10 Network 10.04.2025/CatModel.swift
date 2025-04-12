//
//  CatModel.swift
//  HomeWork 10 Network 10.04.2025
//
//  Created by Dmitry on 11.04.25.
//

import Foundation


struct CatFact: Decodable {
    let fact: String
    let length: Int
}

struct CatImage: Decodable {
    let id: String
    let url: String
    let width: Int
    let height: Int
    let breeds: [Breed]? // опициоанльно если есть порода
    
}

struct Breed: Decodable {
    let name: String?
}

// Для парсинга ответа с фактами
struct CatFactsResponse: Decodable {
    let data: [CatFact]
}
