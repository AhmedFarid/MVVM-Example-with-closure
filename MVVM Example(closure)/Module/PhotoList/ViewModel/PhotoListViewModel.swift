//
//  PhotoListViewModel.swift
//  MVVM Example(closure)
//
//  Created by macbook on 23/09/2022.
//

import Foundation

class PhotoListViewModel {
  
  let apiService: APIServicesProtocol
  
  private var photos: [Photo] = [Photo]()
  
  var reloadTableViewClosure: (()->())?
  var updateLoadingStatus: (()->())?
  var showAlertClosure: (()->())?

  
  private var cellViewModel: [PhotoListCellViewModel] = [PhotoListCellViewModel] () {
    didSet {
      self.reloadTableViewClosure?()
    }
  }
  
  var state: State = .empty {
    didSet {
      self.updateLoadingStatus?()
    }
  }
  
  var alertMessage: String? {
    didSet {
      self.showAlertClosure?()
    }
  }
  
  var numberOfCells: Int {
    return cellViewModel.count
  }
  
  var isAllowSegue: Bool = false
  var selectedPhoto: Photo?
  
  init(apiService: APIServicesProtocol = APIService()) {
    self.apiService = apiService
  }
  
  func initFetch() {
    state = .loading
    apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
      guard let self = self else {return}
      
      guard error == nil else {
        self.state = .error
        self.alertMessage = error?.rawValue
        return
      }
      self.processFetchedPhoto(photos: photos)
      self.state = .populated
    }
  }
  
  private func processFetchedPhoto(photos: [Photo]) {
    self.photos = photos
    var vms = [PhotoListCellViewModel]()
    for photo in photos {
      vms.append(createCellViewModel(photo: photo))
    }
    self.cellViewModel = vms
  }
  
  func createCellViewModel(photo: Photo) -> PhotoListCellViewModel {
    var descTextContainer: [String] = [String]()
    
    if let camera = photo.camera {
      descTextContainer.append(camera)
    }
    
    if let description = photo.description {
      descTextContainer.append(description)
    }
    
    let desc = descTextContainer.joined(separator: " - ")
    
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return PhotoListCellViewModel(titleText: photo.name, descText: desc, imageUrl: photo.image_url, dateText: dateFormatter.string(from: photo.created_at))
  }
  
  func getCellViewModel(at indexPath: IndexPath) -> PhotoListCellViewModel {
    return cellViewModel[indexPath.row]
  }
  
  func userPressed(at indexPath: IndexPath) {
    let photo = self.photos[indexPath.row]
    if photo.for_sale {
      self.isAllowSegue = true
      self.selectedPhoto = photo
    }else {
      self.isAllowSegue = false
      self.selectedPhoto = nil
      self.alertMessage = "This item is not for sale"
    }
  }
}
