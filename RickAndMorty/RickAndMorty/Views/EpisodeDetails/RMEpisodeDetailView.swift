//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import UIKit

final class RMEpisodeDetailView: UIView {

    private var episodeDetailViewViewModel: RMEpisodeDetailViewViewModel? {
        //configuracion al obtener el ViewModel
        didSet {
            spinner.stopAnimating()
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
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .systemYellow
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - Func Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // no resaltar el celda seleccionada
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}


// Para configurar el CollectionViewCompositionLayout
extension RMEpisodeDetailView {
    
    /// Creación del diseño de la sección
    /// - Parameter section: Cantidad de las secciones a crear
    /// - Returns: Devuelve una colección del diseño de la sección
    func layoutSection(for section: Int) -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                            heightDimension: .fractionalHeight(1)))
        // agregar margen a las cell
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                       heightDimension: .absolute(100)),
                                                     subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
