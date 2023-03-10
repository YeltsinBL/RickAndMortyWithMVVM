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
        return characterDetailViewViewModel.sections.count
    }
    
    /// Cantidad de elementos en el Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    /// Agregar los datos del ViewModel a las celdas
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if indexPath.section == 0 {
            cell.backgroundColor = .systemPink
        } else if indexPath.section == 1 {
            cell.backgroundColor = .systemGray
        }else {
            cell.backgroundColor = .systemGreen
        }
        return cell
        
    }
    
    
}
