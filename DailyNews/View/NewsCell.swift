//
//  NewsCell.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import UIKit

class NewsCell: UITableViewCell {
    
    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private var viewModel: NewsCellViewModel?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        picImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
    }
    
    func setCell(viewModel: NewsCellViewModel) {
        self.viewModel = viewModel
        
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
        
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        picImageView.layer.cornerRadius = 8
        picImageView.contentMode = .scaleAspectFill
        
        self.picImageView.image = UIImage(systemName: "newspaper")
        if let url = viewModel.imageUrl, let cachedImage = NewsManager.shared.imageCache.object(forKey: url as NSURL){
            self.picImageView.image = cachedImage
        }else {
            if let url = viewModel.imageUrl {
                NewsManager.shared.fetchImage(from: url) { [weak self] image in
                    if let image = image {
                        DispatchQueue.main.async {
                            self?.picImageView.image = image
                        }
                    }
                }
            }
        }
    }
}
