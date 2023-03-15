//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    /// Busca los detalles del episodio
    func didFetchEpisodeDetail()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointURL: URL?
    
    private var dataTuple: (RMEpisode, [RMCharacter])? {
        didSet {
            // notificamos a nuestro delegado de la vista que ya puede leer datos de este modelo
            delegate?.didFetchEpisodeDetail()
        }
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    //MARK: - Init
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
    }
    
    
    //MARK: - Func Public
    
    //MARK: - Func Private
    
    /// Buscar la información del episodio
    public func fetchEpisodeData() {
        guard let url = endpointURL,
        let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
//                print("Datos: \(String(describing: model))")
                self?.fetchRelatedCharacters(episode: model)
            case .failure:
                break
            }
        }
    }
    
    /// Buscar los personajes relacionados
    /// - Parameter episode: Modelo de un episodio
    private func fetchRelatedCharacters(episode: RMEpisode) {
        
        // crear una coleccion de Solicitudes
      /**
          Primero crea una colección de URL a partir de los personajes y
          luego crea una colección de solicitudes a partir de la colección de URL
       **/
        let requests: [RMRequest] = episode.characters.compactMap {
            // Crea una coleccion de URL a partir de los personajes
            return URL(string: $0)
        }.compactMap {
            // Crear una Solicitud con las URL de los personajes
            return RMRequest(url: $0)
        }
        
        // DispatchGroup: notifica cuando se ha terminado de realizar todas las solicitudes pero devuelve la informacion aleatoriamente
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        // Repetimos la solicitud
        for request in requests {
            // Idicamos que inicie
            group.enter()
            RMService.shared.execute(request, expecting: RMCharacter.self) { result in
                // esto es lo ultimo que se ejecutara antes de salir de esta ejecucion
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        // notificar en el hilo principal que se hizo todas las solicitudes
        group.notify(queue: .main) {
            self.dataTuple = (
                episode,
                characters
            )
        }
        
    }
    
    
}
