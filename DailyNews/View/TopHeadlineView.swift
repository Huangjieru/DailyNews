//
//  TopHeadlineView.swift
//  DailyNews
//
//  Created by JRU on 2025/3/21.
//

import UIKit

class TopHeadlineView: UIView {
    
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    func setView(viewModel: TopHeadlineViewModel) {
        newsTitle.text = viewModel.title
        
        self.newsImageView.image = UIImage(systemName: "newspaper")
        if let url = viewModel.imageUrl, let cachedImage = NewsManager.shared.imageCache.object(forKey: url as NSURL){
            self.newsImageView.image = cachedImage
        }else {
            if let url = viewModel.imageUrl {
                NewsManager.shared.fetchImage(from: url) { [weak self] image in
                    if let image = image {
                        DispatchQueue.main.async {
                            self?.newsImageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    private func setUpView() {
        let bundle = Bundle.init(for: self.classForCoder)
        let nib = UINib.init(nibName: "TopHeadlineView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 32),
            view.heightAnchor.constraint(equalToConstant: 250),
        ])
        
        newsImageView.layer.cornerRadius = 10
    }
}
