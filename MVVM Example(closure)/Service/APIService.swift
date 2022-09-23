//
//  APIService.swift
//  MVVM Example(closure)
//
//  Created by macbook on 23/09/2022.
//

import Foundation

enum APIError: String, Error {
  case noNetwork = "No Network"
  case serverOverload = "Server Is Overloaded"
  case permissionDenied = "You don't have permission"
}

protocol APIServicesProtocol {
  func fetchPopularPhoto(completion: @escaping (_ success: Bool, _ photos: [Photo], _ error: APIError? )->())
}

class APIService: APIServicesProtocol {
  func fetchPopularPhoto( completion complete: @escaping ( _ success: Bool, _ photos: [Photo], _ error: APIError?)->()) {
    DispatchQueue.global().async {
      sleep(3)
      let path = Bundle.main.path(forResource: "content", ofType: "json")!
      let data = try! Data(contentsOf: URL(fileURLWithPath: path))
      let decoder = JSONDecoder()
      decoder.dateDecodingStrategy = .iso8601
      let photos = try! decoder.decode(Photos.self, from: data)
      complete(true, photos.photos, nil)
    }
  }
}
