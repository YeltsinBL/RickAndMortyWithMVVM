//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    /// Navega al detalle del Personaje desde el Detalle del Episodio
    /// - Parameters:
    ///   - detailView: Vista del detalle del Episodio
    ///   - character: modelo del personaje
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter
    )
}

final class RMEpisodeDetailView: UIView {

    public weak var delegate: RMEpisodeDetailViewDelegate?
    
    private var episodeDetailViewViewModel: RMEpisodeDetailViewViewModel? {
        //configuración al obtener el modelo del ViewModel: oculta el spinner y muestra el collectionview
        didSet {
            spinner.stopAnimating()
            self.collectionView?.reloadData()
            self.collectionView?.isHidden = false
            //desvancer luego de obtener el modelo
            UIView.animate(withDuration: 0.3) {
                    self.collectionView?.alpha = 1
            }
        }
    }
    
    // crear un diseño compositivo
    private var collectionView: UICollectionView?
    
    /// Mostrar una rueda giratorial para cargar
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true // se oculte cuando se detenga
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addCustomSubViews(collectionView, spinner)
        self.collectionView = collectionView
        setUpConstraints()
        
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Func Private
    
    /// Configurar los constraints a los elementos
    private func setUpConstraints() {
        guard let collectionView = collectionView else { return }
        
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
    
    /// Creación de CollectionView mediante un diseño de composición
    /// - Returns: Devuelve un UICollectionView
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            return self.layoutSection(for: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0 // que sea opaco
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(RMEpisodeInfoCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }
    
    //MARK: - Func Public
    
    /// Relacionar los datos del ViewModel con sus respectivos elementos de la vista
    /// - Parameter episodeDetailViewViewModel: ViewModel del detalle del Episodio
    public func configure(with episodeDetailViewViewModel: RMEpisodeDetailViewViewModel) {
        self.episodeDetailViewViewModel = episodeDetailViewViewModel
    }
}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: - Func DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = episodeDetailViewViewModel?.episodeCellViewModel else { return 0 }

        // obtenemos el tipo de sección de acuerdo a la posición
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModel):
            return viewModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = episodeDetailViewViewModel?.episodeCellViewModel
        else { fatalError("No hay ViewModel")  }

        // obtenemos el tipo de sección de acuerdo a la posición
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
            // Obtenemos el ViewModel de acuerdo a la fila
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMEpisodeInfoCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModel):
            let cellViewModel = viewModel[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Cantidad de las secciones en el ViewModel
        return episodeDetailViewViewModel?.episodeCellViewModel.count ?? 0
    }
    
    //MARK: - Func Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no resaltar el celda seleccionada
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let episodeCellViewModel = episodeDetailViewViewModel else { return }
        // Obtener la sección del ViewModel de acuerdo al índice
        let section = episodeCellViewModel.episodeCellViewModel[indexPath.section]
        switch section {
        case .information:
            break
        case .characters:
            guard let character = episodeCellViewModel.character(at: indexPath.row) else {
                return
            }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
            
        }
    }
}


// Para configurar el CollectionViewCompositionLayout
extension RMEpisodeDetailView {
    
    /// Creación del diseño por sección
    /// - Parameter section: Cantidad de las secciones a crear
    /// - Returns: Devuelve una colección del diseño de la sección
    func layoutSection(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = episodeDetailViewViewModel?.episodeCellViewModel
        else { return createInfoLayout() }
        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
            
        }
        
    }
    
    /// Creación del diseño de la  sección Información
    /// - Returns: Devuelve una colección del diseño de la sección Información
    func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        // agregar margen a las cell
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(80)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    /// Creación del diseño de la  sección Personajes
    /// - Returns: Devuelve una colección del diseño de la sección Personajes
    func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        // agregar margen a las cell
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(260)),
            subitems: [item, item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}
