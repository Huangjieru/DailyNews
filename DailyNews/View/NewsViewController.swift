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
        
        viewModel.fetchNews()
        
        refreshControl()
    }
}
// MARK: - Table view data source
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.newsCellVMs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsCell
        print("DEBUG cellForRowAt: \(viewModel.newsCellVMs.count)")
        let newsCellVM = viewModel.newsCellVMs[indexPath.row]
        cell.setCell(viewModel: newsCellVM)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let newsDetail = viewModel.newsCellVMs[indexPath.row].link{
            let safariViewController = SFSafariViewController(url: newsDetail)
            present(safariViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
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
        
        //下方重新抓取資料並顯示
        viewModel.fetchNews()
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
        viewModel.fetchNews()
        tableView.refreshControl?.endRefreshing()
    }
}

