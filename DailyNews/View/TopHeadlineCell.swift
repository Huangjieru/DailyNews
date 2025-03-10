//
//  TopHeadlineCell.swift
//  DailyNews
//
//  Created by JRU on 2025/3/6.
//

import UIKit

class TopHeadlineCell: UITableViewCell {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    private var viewModel: TopHeadlineViewModel?
    
    func setCell(viewModel: TopHeadlineViewModel) {
        self.viewModel = viewModel
    }
}
