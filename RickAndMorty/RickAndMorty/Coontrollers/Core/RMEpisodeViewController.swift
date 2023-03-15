//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Controlador para mostrar y buscar Episodios
final class RMEpisodeViewController: UIViewController, RMEpisodeListViewDelegate {
    
    private let episodeListView = RMEpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Episodios"
        
        setUpConstrains()
        episodeListView.delegate = self
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
    private func didTapSearch(){
        
    }
    
    private func setUpConstrains() {
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    // MARK: - Implementación del RMEpisodeListViewDelegate
    
    func rmEpisodeListView(_ episodeListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // LLamamos al controller del detalle de los personajes
        let episodeDetailViewController = RMEpisodeDetailViewController(url: URL(string: episode.url))
        // Que no muestre el título en modo grande
        episodeDetailViewController.navigationItem.largeTitleDisplayMode = .never
        // Navegamos a la vista del detalle
        navigationController?.pushViewController(episodeDetailViewController, animated: true)
        
    }
    
}
