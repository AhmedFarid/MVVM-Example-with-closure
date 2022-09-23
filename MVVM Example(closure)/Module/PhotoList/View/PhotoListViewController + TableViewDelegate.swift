//
//  PhotoListViewController + TableViewDelegate.swift
//  MVVM Example(closure)
//
//  Created by macbook on 24/09/2022.
//

import UIKit


extension PhotoListViewController: UITableViewDelegate, UITableViewDataSource {
  
  func setupTabelView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "PhotoListCell", bundle: nil), forCellReuseIdentifier: "PhotoListCell")
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoListCell", for: indexPath) as! PhotoListCell
    let cellVM = viewModel.getCellViewModel(at: indexPath)
    cell.photoListCellViewModel = cellVM
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfCells
  }
  
  func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    self.viewModel.userPressed(at: indexPath)
    if viewModel.isAllowSegue {
      let vc = PhotoDetailViewController(nibName: "PhotoDetailViewController", bundle: nil)
      if let photo = viewModel.selectedPhoto {
        vc.imageUrl = photo.image_url
      }
      navigationController?.pushViewController(vc, animated: true)
      return indexPath
    }else {
      return nil
    }
  }
}
