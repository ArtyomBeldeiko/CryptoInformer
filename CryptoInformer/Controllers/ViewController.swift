//
//  ViewController.swift
//  CryptoInformer
//
//  Created by Artyom Beldeiko on 18.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    private var currencies = [Currency]()
    private var filteredCurrencies = [Currency]()
    
//    MARK: RefreshControl
    
    private let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(tableUpdate), for: .valueChanged)
        return refreshControl
    }()
    
    private let cryptoTable: UITableView = {
        let table = UITableView()
        table.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return table
    }()
    
//    MARK: SearchBar
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(cryptoTable)
        
        navigationBarConfiguration()
        searchBarConfiguration()
        
        cryptoTable.delegate = self
        cryptoTable.dataSource = self
        cryptoTable.refreshControl = refreshControl
        cryptoTable.separatorColor = .customGray
        
        fetchRequest()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoTable.frame = view.bounds
    }
    
//    MARK: NavigationBarConfiguration
    
    private func navigationBarConfiguration() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .customBlue
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
//    MARK: SearchBarConfiguration
    
    private func searchBarConfiguration() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        searchController.searchBar.barTintColor = .customGray
        searchController.searchBar.tintColor = .customGray
        searchController.searchBar.searchTextField.textColor = .customGray
        definesPresentationContext = true
    }
    
//    MARK: FetchRequest
    
    private func fetchRequest() {
        NetworkManager.shared.getRates { result in
            switch result {
            case .success(let rate):
                for (key, value) in rate.rates {
                    let currency = Currency(currencyName: key, rate: value)
                    self.currencies.append(currency)
                }
                
                DispatchQueue.main.async {
                    self.cryptoTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @objc private func tableUpdate(sender: UIRefreshControl) {
        currencies.removeAll()
        fetchRequest()
        sender.endRefreshing()
    }
    
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredCurrencies.count
        }
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { return UITableViewCell()}
        
        var currency: Currency
        
        if isFiltering {
            currency = filteredCurrencies[indexPath.row]
        } else {
            currency = currencies[indexPath.row]
        }
        
        cell.cryptoLabel.text = currency.currencyName
        cell.cryptoRate.text = String(currency.rate)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}

// MARK: UISearchResultsUpdating

extension ViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredCurrencies = currencies.filter({ (currency: Currency) -> Bool in
            return currency.currencyName.lowercased().contains(searchText.lowercased())
        })
        
        cryptoTable.reloadData()
    }
}

