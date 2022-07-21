//
//  ViewModel.swift
//  DemoTest
//
//  Created by Sahil Garg on 21/07/22.
//
import Foundation
import UIKit

class ViewModel {

    typealias ViewModelAPICallback = (Bool,String) -> Void
    var completion: ViewModelAPICallback?
    
    private let cache = NSCache<NSNumber, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var tempAnimeList = [AnimeModel]()
    var animeList = [AnimeModel]()
    
    func getDataFromAPI(completionHandler: @escaping(Bool,String) -> Void) {
        self.completion = completionHandler
        if let url = URL(string: UrlConfig.BASE_URL + UrlConfig.GET_DATA) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    self.completion?(false,error.localizedDescription)
                } else {
                    if let data = data {
                        do {
                            let animeResultModel = try JSONDecoder().decode(AnimeResultModel.self, from: data)
                            self.animeList = animeResultModel.results
                            self.tempAnimeList = self.animeList
                            self.completion?(true,"")
                        }
                        catch (let error) {
                            print(error)
                            self.completion?(false,error.localizedDescription)
                        }
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func loadImage(index: Int,completion: @escaping (UIImage?) -> ()) {
        let itemNumber = NSNumber(value: index)
        if let cachedImage = self.cache.object(forKey: itemNumber) {
            completion(cachedImage)
        } else {
            utilityQueue.async {
                guard let url = URL(string: self.tempAnimeList[index].imageUrl) else { return }
                guard let data = try? Data(contentsOf: url) else { return }
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.cache.setObject(image, forKey: itemNumber)
                        completion(image)
                    }
                }
            }
        }
    }
        
}
