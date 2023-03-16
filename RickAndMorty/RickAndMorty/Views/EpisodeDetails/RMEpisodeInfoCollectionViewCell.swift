//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 15/03/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    private let titleLable: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    private let valueLable: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textAlignment = .right
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addCustomSubViews(titleLable, valueLable)
        setUpLayer()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLable.text = nil
        valueLable.text = nil
    }
    
    private func setUpLayer() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            titleLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            titleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            valueLable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            valueLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            valueLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            titleLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47),
            valueLable.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.47)
        ])
    }
    
    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel){
        titleLable.text = viewModel.title
        valueLable.text = viewModel.value
    }
    
}
