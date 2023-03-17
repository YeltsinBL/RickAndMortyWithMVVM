//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 13/03/23.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController, RMEpisodeDetailViewViewModelDelegate,
                                           RMEpisodeDetailViewDelegate {

    
    private let episodeDetailViewViewModel: RMEpisodeDetailViewViewModel
    
    private let episodeDetailView = RMEpisodeDetailView()
    
    //MARK: - Init
    
    init(url: URL?) {
        self.episodeDetailViewViewModel = RMEpisodeDetailViewViewModel(endpointURL: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Cycle Life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(episodeDetailView)
        episodeDetailView.delegate = self
        setUpConstraints()
        title = "Episodio"
        // Botón en la parte superior derecha
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(didTapShared)
        )
        episodeDetailViewViewModel.delegate = self
        // buscamos la información del episodio después de crear la vista del detalle
        episodeDetailViewViewModel.fetchEpisodeData()
        didFetchEpisodeDetail()
    }
    
    
    //MARK: - Func

    private func setUpConstraints(){
        NSLayoutConstraint.activate([
            episodeDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeDetailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeDetailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    @objc
    private func didTapShared() {
        
    }
    
    //MARK: - Func View Delegate
    
    func rmEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        // LLamamos al controller del detalle de los personajes
        let characterDetailViewController = RMCharacterDetailViewController(
            characterDetailViewViewModel: .init(character: character)
        )
        characterDetailViewController.title = character.name
        // Que no muestre el título en modo grande
        characterDetailViewController.navigationItem.largeTitleDisplayMode = .never
        // Navegamos a la vista del detalle
        navigationController?.pushViewController(characterDetailViewController, animated: true)
    }
    
    //MARK: - Func ViewModel Delegate
    
    func didFetchEpisodeDetail() {
        episodeDetailView.configure(with: episodeDetailViewViewModel)
    }
}
