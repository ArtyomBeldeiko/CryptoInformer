//
//  CryptoTableViewCell.swift
//  CryptoInformer
//
//  Created by Artyom Beldeiko on 19.10.22.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    static let identifier = "CryptoTableViewCell"
    
    let cryptoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cryptoRate: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Helvetica-Bold", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cryptoLabel)
        contentView.addSubview(cryptoRate)
        contentView.addSubview(favouriteButton)
        
        setConstraints()
    }
    
    private func setConstraints() {
        let cryptoLabelConstraints = [
            cryptoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cryptoLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let favouriteButtonContraints = [
            favouriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            favouriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favouriteButton.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let cryptoRateConstraints = [
            cryptoRate.trailingAnchor.constraint(equalTo: favouriteButton.leadingAnchor, constant: -20),
            cryptoRate.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(cryptoLabelConstraints)
        NSLayoutConstraint.activate(favouriteButtonContraints)
        NSLayoutConstraint.activate(cryptoRateConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
