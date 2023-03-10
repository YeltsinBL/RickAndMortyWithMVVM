//
//  RMCharacterDetailView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 9/03/23.
//

import UIKit

/// Vista para mostrar toda la información de un solo personaje
final class RMCharacterDetailView: UIView {

    public var collectionView: UICollectionView?
    
    private let characterDetailViewViewModel: RMCharacterDetailViewViewModel
    
    //MARK: - Elementos de la vista
    
    /// Mostrar una rueda giratorial al cargar
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true // se oculte cuando se detenga
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Init
    
    init(frame: CGRect, characterDetailViewViewModel: RMCharacterDetailViewViewModel) {
        self.characterDetailViewViewModel = characterDetailViewViewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addCustomSubViews(collectionView, spinner)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func
    
    /// Agregar los constrains
    private func addConstraints() {
        // Devolvemos la vista del Collection porque puede ser null
        guard let collectionView = collectionView else { return  }
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    /// Crea un CollectionView personalizado
    /// - Returns: retorna un CollectionView
    private func createCollectionView() -> UICollectionView {
        // Hacemos un diseño compositivo: índice de la sección y entorno para el diseño del Collection
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
            return self.createSection(for: sectionIndex)
        }
        // Instanciamos un CollectionView
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    /// Creación del diseño de composición para el Collection
    /// - Parameter sectionIndex: Indice de la sección
    /// - Returns: Devuelve una sección de diseño del Collection
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        /// Obtener todos los tipos de Secciones
        let sectionTypes = characterDetailViewViewModel.sections
        
        /// Crear los CollectionViewCompositionalLayout de acuerdo al tipo de Secciones
        switch sectionTypes[sectionIndex]{
            case .photo:
                return createPhotoSectionLayout()
            case .information:
                return createInformationSectionLayout()
            case .episodes:
                return createEpisodesSectionLayout()
        }
        
    }
    
    /// Crea el diseño de la sección de la foto
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento de diseño de colección con un tamaño
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: 10,
                                                        trailing: 0)
        
        // Instanciamos un Grupo de diseño de colección en vertical
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    /// Crea el diseño de la sección de la información
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    private func createInformationSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento de diseño de colección con un tamano de diseno
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: 10,
                                                        trailing: 0)
        
        // Instanciamos un Grupo de diseño de colección en vertical
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    /// Crea el diseño de la sección de los episodios
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    private func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento de diseño de colección con un tamano de diseno
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
        )
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: 10,
                                                        trailing: 0)
        
        // Instanciamos un Grupo de diseño de colección en vertical
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

}
