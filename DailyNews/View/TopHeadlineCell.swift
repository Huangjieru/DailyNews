//
//  TopHeadlineCell.swift
//  DailyNews
//
//  Created by JRU on 2025/3/6.
//

import UIKit

class TopHeadlineCell: UITableViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: TopHeadlineCellViewModel?
    private var timer: Timer?
    
    override func awakeFromNib() {
        super .awakeFromNib()
        scrollView.delegate = self
    }
    
    func setCell(viewModel: TopHeadlineCellViewModel) {
        self.viewModel = viewModel
        
        pageControl.numberOfPages = viewModel.topHeadlineVMs.count - 2
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width  - 32) * (CGFloat(viewModel.topHeadlineVMs.count) ), height: 250)
        scrollView.isPagingEnabled = true
        if viewModel.topHeadlineVMs.isEmpty { return }
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
        for (index, vm) in viewModel.topHeadlineVMs.enumerated() {
            let view = TopHeadlineView()
            view.setView(viewModel: vm)
            view.frame = CGRect(x: (UIScreen.main.bounds.width - 32) * CGFloat(index), y: 0, width: (UIScreen.main.bounds.width - 32), height: 250)
            self.scrollView.addSubview(view)
            self.scrollView.layoutIfNeeded()
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(viewModel.topHeadlineVMs.count) * scrollView.frame.width, height: scrollView.frame.height)
        scrollView.contentOffset = CGPoint(x: scrollView.frame.width, y: 0)
        startTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func autoScroll() {
        viewModel?.autoScroll()
        scrollView.contentOffset = CGPoint(x: (UIScreen.main.bounds.width  - 32) * CGFloat((viewModel?.showImageIndex)!), y: 0)
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
    }
}

extension TopHeadlineCell: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = self.scrollView.contentOffset.x
        switch offsetX {
        case 0 :
            
            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.width * CGFloat((viewModel?.topHeadlineVMs.count)!), y: 0)
            self.pageControl.currentPage = (viewModel?.topHeadlineVMs.count ?? 0)!
            
        case self.scrollView.frame.width * CGFloat((viewModel?.topHeadlineVMs.count ?? 0)):
            
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.frame.width, y: 0)
            self.pageControl.currentPage = 0
        default:
            
            self.pageControl.currentPage = Int(offsetX / (UIScreen.main.bounds.width - 32) - 1)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        viewModel?.showImageIndex = Int(scrollView.contentOffset.x / (UIScreen.main.bounds.width - 32))
        startTimer()
    }
}
