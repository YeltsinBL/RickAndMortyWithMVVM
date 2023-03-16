//
//  RMEpisodeInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 15/03/23.
//

import UIKit

final class RMEpisodeInfoCollectionViewCell: UICollectionViewCell {
    
    static let cellIdentifier = "RMEpisodeInfoCollectionViewCell"
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMEpisodeInfoCollectionViewCellViewModel){
        
    }
    
}
