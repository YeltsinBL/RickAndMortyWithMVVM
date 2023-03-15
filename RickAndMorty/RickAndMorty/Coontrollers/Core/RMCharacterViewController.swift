//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Controlador para mostrar y buscar Personajes
final class RMCharacterViewController: UIViewController, RMCharacterListViewDelegate  {

    private let characterListView = RMCharacterListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Personajes"
        
        setUpConstrains()
        characterListView.delegate = self
        addSearchButton()
    }
    
    // MARK: - Func
    
    /// Botón de búsqueda en la parte superior derecha
    private func addSearchButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .search,
            target: self,
            action: #selector(didTapSearch)
        )
    }
    
    @objc
    /// Mostrar la vista de la búsqueda
    private func didTapSearch(){
        // Instanciar
        let searchViewController = RMSearchViewController(config: .init(types: .character))
        // No mostrar el título grande
        searchViewController.navigationItem.largeTitleDisplayMode = .never
        // Navegar
        navigationController?.pushViewController(searchViewController, animated: true)
        
    }
    
    private func setUpConstrains() {
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    // MARK: - Implementación del RMCharacterListViewDelegate
    
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        // Creamos una instancia del ViewModel
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        // LLamamos al controller del detalle de los personajes
        let characterDetailViewController = RMCharacterDetailViewController(characterDetailViewViewModel: viewModel)
        // Que no muestre el título en modo grande
        characterDetailViewController.navigationItem.largeTitleDisplayMode = .never
        // Navegamos a la vista del detalle
        navigationController?.pushViewController(characterDetailViewController, animated: true)
        
    }
    
}
