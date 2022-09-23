//
//  PhotoListViewController.swift
//  MVVM Example(closure)
//
//  Created by macbook on 23/09/2022.
//

import UIKit

class PhotoListViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  lazy var viewModel: PhotoListViewModel = {
    return PhotoListViewModel()
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupMainView()
    setupTabelView()
    setupViewModel()
  }
  
  func setupMainView() {
    self.navigationItem.title = "Photo List"
  }
  
  func setupViewModel() {
    viewModel.showAlertClosure = { [weak self] in
      guard let self = self else {return}
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {return}
        if let message = self.viewModel.alertMessage {
          self.showAlert(message)
        }
      }
    }
    
    
    
    
    viewModel.updateLoadingStatus = { [weak self] in
      guard let self = self else {return}
      DispatchQueue.main.async { [weak self] in
        guard let self = self else {return}
        
        switch self.viewModel.state {
        case .empty, .error:
          self.activityIndicator.stopAnimating()
          UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 0.0
            self.activityIndicator.alpha = 0.0
          }
        case .loading:
          self.activityIndicator.startAnimating()
          UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 0.0
            self.activityIndicator.alpha = 1.0
          }
        case .populated:
          self.activityIndicator.stopAnimating()
          UIView.animate(withDuration: 0.2) {
            self.tableView.alpha = 1.0
            self.activityIndicator.alpha = 0.0
          }
        }
      }
    }
    
    
    
    viewModel.reloadTableViewClosure = { [weak self] in
      guard let self = self else {return}
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
    viewModel.initFetch()
  }
  
  func showAlert( _ message: String ) {
    let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
    alert.addAction( UIAlertAction(title: "Ok", style: .cancel, handler: nil))
    self.present(alert, animated: true, completion: nil)
  }
}

