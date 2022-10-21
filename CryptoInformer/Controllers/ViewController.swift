//
//  ViewController.swift
//  CryptoInformer
//
//  Created by Artyom Beldeiko on 18.10.22.
//

import UIKit

class ViewController: UIViewController {
    
    var currencies = [Currency]()
    
    private let cryptoTable: UITableView = {
        let table = UITableView()
        table.register(CryptoTableViewCell.self, forCellReuseIdentifier: CryptoTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(cryptoTable)
        
        cryptoTable.delegate = self
        cryptoTable.dataSource = self
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cryptoTable.frame = view.bounds
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoTableViewCell.identifier, for: indexPath) as? CryptoTableViewCell else { return UITableViewCell()}
        
        let currency = currencies[indexPath.row]
        
        cell.cryptoLabel.text = currency.currencyName
        cell.cryptoRate.text = String(currency.rate)
        
        return cell
    }
}

