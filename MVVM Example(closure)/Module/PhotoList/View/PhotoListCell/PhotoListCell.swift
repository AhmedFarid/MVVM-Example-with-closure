//
//  PhotoListCell.swift
//  MVVM Example(closure)
//
//  Created by macbook on 23/09/2022.
//

import UIKit
import SDWebImage

class PhotoListCell: UITableViewCell {
  
  @IBOutlet weak var mainImageView: UIImageView!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  @IBOutlet weak var nameLabel: UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
   
  var photoListCellViewModel: PhotoListCellViewModel? {
    didSet {
      nameLabel.text = photoListCellViewModel?.titleText
      descriptionLabel.text = photoListCellViewModel?.descText
      mainImageView.sd_setImage(with: URL(string: photoListCellViewModel?.imageUrl ?? ""),completed: nil)
      dateLabel.text = photoListCellViewModel?.dateText
    }
  }
  
}
