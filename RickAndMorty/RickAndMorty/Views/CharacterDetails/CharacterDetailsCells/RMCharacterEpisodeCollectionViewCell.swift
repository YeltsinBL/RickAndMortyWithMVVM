//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 10/03/23.
//

import UIKit

final class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    /// Identificador de la Cell
    static let cellIdentifer = "RMCharacterEpisodeCollectionViewCell"
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 8
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    /// Configurar los constraints
    private func setUpConstraints() {
        
    }
    
    /// Recibir el ViewModel para asignarlo a los elementos de la Cell
    /// - Parameter characterEpisodeCollectionViewCellViewModel: Recibe los datos del ViewModel
    public func configure(with characterEpisodeCollectionViewCellViewModel: RMCharacterEpisodeCollectionViewCellViewModel){
        // Obtenemos los datos de las propiedades del protocolo
        characterEpisodeCollectionViewCellViewModel.registerForData { data in
            print("Datos: \(String(describing: data))")
        }
        characterEpisodeCollectionViewCellViewModel.fetchEpisode()
    }
    
}
