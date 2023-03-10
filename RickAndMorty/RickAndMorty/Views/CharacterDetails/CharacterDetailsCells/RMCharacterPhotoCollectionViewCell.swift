//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 10/03/23.
//

import UIKit

final class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    /// Identificador de la Cell
    static let cellIdentifer = "RMCharacterPhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
       let image = UIImageView()
        // la imágen ocupe todo el tamaño
        image.contentMode = .scaleAspectFill
        // cortar la imágen en sus limites
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
        
        contentView.addCustomSubViews(imageView)
        setUpConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    /// Configurar los constraints
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    /// Recibir el ViewModel para asignarlo a los elementos de la Cell
    /// - Parameter characterPhotoCollectionViewCellViewModel: Recibe los datos del ViewModel
    public func configure(with characterPhotoCollectionViewCellViewModel: RMCharacterPhotoCollectionViewCellViewModel){
        characterPhotoCollectionViewCellViewModel.fetchImage { [weak self]result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self?.imageView.image = UIImage(data: success)
                }
            case .failure:
                break
            }
        }
    }
    
}
