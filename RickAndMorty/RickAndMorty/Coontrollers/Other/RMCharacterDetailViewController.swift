//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 9/03/23.
//

import UIKit

// Controller para mostrar más información de un Personaje
final class RMCharacterDetailViewController: UIViewController {

    private let characterDetailViewViewModel: RMCharacterDetailViewViewModel
    
    private let characterDetailView: RMCharacterDetailView
    
    // MARK: - Init
    
    init(characterDetailViewViewModel: RMCharacterDetailViewViewModel) {
        self.characterDetailViewViewModel = characterDetailViewViewModel
        self.characterDetailView = RMCharacterDetailView(frame: .zero, characterDetailViewViewModel: characterDetailViewViewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Ciclo de vida
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = characterDetailViewViewModel.title
        view.addSubview(characterDetailView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShared)
        )
        addConstraints()
        
        characterDetailView.collectionView?.dataSource = self
        characterDetailView.collectionView?.delegate = self
        
    }

    // MARK: - Func
    
    /// Agregar los constraint
    private func addConstraints() {
        NSLayoutConstraint.activate([
            characterDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    @objc // Selector de Object C
    /// Compartir la información del personaje
    private func didTapShared(){
        
    }
  
}

//MARK: - Implementación del CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - Func DataSource - Almacenar los datos en el Collection
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        /// Cantidad de tipos de secciones
        return characterDetailViewViewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /// Cantidad de elementos a mostrar de acuerdo a la sección
        
        /// Obtenemos el tipo de sección actual mediante el indice de la sección
        let sectionType = characterDetailViewViewModel.sections[section]
        // De acuerdo a la cantidad de veces inicializadas se crean las celdas para las secciones
        switch sectionType {
        case .photo:
            return 1
        case .information(let characterInfoCollectionViewCellViewModel):
            return characterInfoCollectionViewCellViewModel.count
        case .episodes(let characterEpisodeCollectionViewCellViewModel):
            return characterEpisodeCollectionViewCellViewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// Agrega los datos del ViewModel a las celdas
        
        /// Obtener la sección actual para identificar la cell y enviar los datos de sus respectivos ViewModel
        let sectionType = characterDetailViewViewModel.sections[indexPath.section]
        // De acuerdo a la sección se identifica y envia los datos
        switch sectionType {
        case .photo(let characterPhotoCollectionViewCellViewModel):
            guard  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterPhotoCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterPhotoCollectionViewCell else {
                fatalError("Sin soporte")
            }
            cell.configure(with: characterPhotoCollectionViewCellViewModel)
            return cell
            
        case .information(let characterInfoCollectionViewCellViewModel):
            guard  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterInfoCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterInfoCollectionViewCell else {
                fatalError("Sin soporte")
            }
            // como el ViewModel es un array, solo pasamos el elemento
            cell.configure(with: characterInfoCollectionViewCellViewModel[indexPath.row])
            return cell
            
        case .episodes(let characterEpisodeCollectionViewCellViewModel):
            guard  let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer,
                for: indexPath
            ) as? RMCharacterEpisodeCollectionViewCell else {
                fatalError("Sin soporte")
            }
            // como el ViewModel es un array, solo pasamos el elemento
            cell.configure(with: characterEpisodeCollectionViewCellViewModel[indexPath.row])
            return cell
            
        }
    }
    
    
}
