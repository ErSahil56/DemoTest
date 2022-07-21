//
//  CountryModel.swift
//  DemoTest
//
//  Created by Sahil Garg on 21/07/22.
//
import UIKit

class AnimeResultModel: Codable {
    let results: [AnimeModel]
}

class AnimeModel: Codable {
    
    let id: Int
    let title: String
    let imageUrl: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "mal_id"
        case title
        case imageUrl = "image_url"
    }
    
}

