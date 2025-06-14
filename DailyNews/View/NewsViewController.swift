//
//  NewsViewController.swift
//  DailyNews
//
//  Created by JRU on 2025/3/2.
//

import UIKit
import SafariServices

class NewsViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = NewsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        bindViewModel()
        
        viewModel.fetchNews(country: "us")
        viewModel.fetchTopHeadline()
        
        refreshControl()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let section = NewsViewModel.Section.topHeadline.rawValue
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: section)) as? TopHeadlineCell
        cell?.stopTimer()
    }
    
    func setView(viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
}
// MARK: - Table view data source
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.setNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewModel.setNumberOfRowsInSection(section: section))
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = NewsViewModel.Section.init(rawValue: indexPath.section)
        switch section {
        case .topHeadline:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopHeadlineCell") as! TopHeadlineCell
            cell.setCell(viewModel: (viewModel.topHeadlineCellVM!))
            return cell
            
        case .news:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
            let newsCellVM = (viewModel.newsCellVMs[indexPath.row])
            cell.setCell(viewModel: newsCellVM)
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsDetail = viewModel.newsCellVMs[indexPath.row].link {
            let safariViewController = SFSafariViewController(url: newsDetail)
            present(safariViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = NewsViewModel.Section.init(rawValue: indexPath.section)
        switch section {
        case .topHeadline:
            return 300
        case .news:
            return 180
        default:
            return 0
        }
    }
}

extension NewsViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetchSearchNews(text: searchBar.text ?? "")
        view.endEditing(true)
    }
    
    //searchBar按cancel按鈕
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        viewModel.fetchNews(country: "us")
    }
}

extension NewsViewController {
    private func setView() {
        title = "News"
        
        searchBar.delegate = self
        searchBar.placeholder = "search news that you want."
        searchBar.showsCancelButton = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TopHeadlineCell", bundle: nil), forCellReuseIdentifier: "TopHeadlineCell")
        tableView.register(UINib(nibName: "NewsCell", bundle: nil), forCellReuseIdentifier: "NewsCell")
        
        activityIndicator.startAnimating()
    }
    
    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.alpha = 0
            }
        }
    }
    
    //更新
    private func refreshControl(){
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
    }
    
    //更新資料與停止更新
    @objc private func pullToRefresh(){
        viewModel.fetchNews(country: "us")
        tableView.refreshControl?.endRefreshing()
    }
}

