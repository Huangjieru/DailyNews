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
        
        self.picImageView.image = UIImage(systemName: "newspaper.fill")
        viewModel.picImage = { [weak self] image in
            DispatchQueue.main.async {
                self?.picImageView.image = image
            }
        }
        
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 0
        
        picImageView.layer.cornerRadius = 8
        picImageView.contentMode = .scaleAspectFill
    }
    
}
