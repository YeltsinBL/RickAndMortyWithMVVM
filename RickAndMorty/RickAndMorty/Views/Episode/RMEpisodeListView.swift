//
//  RMEpisodeListView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import Foundation
import UIKit

protocol RMEpisodeListViewDelegate: AnyObject {
    /// Mostar el detalle del Episodio seleccionado
    /// - Parameters:
    ///   - episodeListView: Tipo de vista actual
    ///   - episode: Los datos que se enviara
    func rmEpisodeListView(
        _ episodeListView: RMEpisodeListView,
        didSelectEpisode episode: RMEpisode)
}

/// Vista que muestra la lista de los episodios
final class RMEpisodeListView: UIView {
    
    // Usar las funciones del Protocolo delegate de una manera débil
    public weak var delegate: RMEpisodeListViewDelegate?
    
    private let characterListViewModel = RMEpisodeListViewViewModel()
    
    /// Mostrar una rueda giratorial al cargar
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true // se oculte cuando se detenga
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    /// Mostrar los personajes en una coleccion
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // especificar el margen
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.alpha = 0 // opacidad
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer)
        // Registramos la vista FooterLoading como pie de pagina del Collection
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.indentifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addCustomSubViews(collectionView, spinner)
        addConstraints()
        
        spinner.startAnimating()
        characterListViewModel.delegate = self //notificar que se actualizara el listado
        characterListViewModel.fetchEpisodes()
        setUpCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Func
    
    /// Agregar todas la constaint de la vista
    private func addConstraints() {
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
    
    /// Configurar la vista de colección
    private func setUpCollectionView() {
        collectionView.dataSource = characterListViewModel
        collectionView.delegate = characterListViewModel
        
    }
    
}

/// Agregamos el protocolo a la ListView
extension RMEpisodeListView: RMEpisodeListViewViewModelDelegate {

    func didLoadInitialEpisodes() {
        // Para que el Collection continúe y vuelva a cargar sus datos
        spinner.stopAnimating()
        collectionView.isHidden = false
        collectionView.reloadData() // Recargar para la búsqueda inicial de los episodios
        UIView.animate(withDuration: 0.4) {
            self.collectionView.alpha = 1
        }
    }
    
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath]) {
        // Informamos al CollectionView que agregue más celdas
        collectionView.performBatchUpdates {
            // Insertamos elementos en el CollectionView en una ruta de índice particular
            self.collectionView.insertItems(at: newIndexPaths)
        }
    }
    
    func didSelectEpisode(_ episode: RMEpisode) {
        // Enviamos los datos al controller
        delegate?.rmEpisodeListView(self, didSelectEpisode: episode)
    }
    
}
