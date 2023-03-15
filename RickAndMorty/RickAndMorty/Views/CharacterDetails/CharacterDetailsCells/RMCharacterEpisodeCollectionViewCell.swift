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
    
    private let seasonLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .semibold)
//        label.textAlignment = .center
        return label
    }()
    private let nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .regular)
//        label.textAlignment = .center
        return label
    }()
    private let airDateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
//        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        setUpLayer()
        contentView.addCustomSubViews(seasonLabel, nameLabel, airDateLabel)
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    override func prepareForReuse() {
        super.prepareForReuse()
        seasonLabel.text = nil
        nameLabel.text = nil
        airDateLabel.text = nil
    }
    /// Configurar el estilo de las Cell
    private func setUpLayer() {
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 2
    }
    /// Configurar los constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            seasonLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            seasonLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            seasonLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            seasonLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            nameLabel.topAnchor.constraint(equalTo: seasonLabel.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            nameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            nameLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            
            airDateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            airDateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant:  10),
            airDateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant:  -10),
            airDateLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
        ])
    }
    
    /// Recibir el ViewModel para asignarlo a los elementos de la Cell
    /// - Parameter characterEpisodeCollectionViewCellViewModel: Recibe los datos del ViewModel
    public func configure(with characterEpisodeCollectionViewCellViewModel: RMCharacterEpisodeCollectionViewCellViewModel){
        // Obtenemos los datos de las propiedades del protocolo
        characterEpisodeCollectionViewCellViewModel.registerForData { [weak self] data in
            self?.seasonLabel.text = "Episodio: " + data.episode
            self?.nameLabel.text = data.name
            self?.airDateLabel.text = "Fecha Emisión: " + data.air_date
        }
        characterEpisodeCollectionViewCellViewModel.fetchEpisode()
        // asignar un color al borde de las cell
        contentView.layer.borderColor = characterEpisodeCollectionViewCellViewModel.borderColor.cgColor
    }
    
}
