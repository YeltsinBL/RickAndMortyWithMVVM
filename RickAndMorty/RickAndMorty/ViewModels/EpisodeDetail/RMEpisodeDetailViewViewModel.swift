//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import Foundation

protocol RMEpisodeDetailViewViewModelDelegate: AnyObject {
    /// Notifica que ya se encontró la información del episodio y esta listo para utilizarlo
    func didFetchEpisodeDetail()
}

final class RMEpisodeDetailViewViewModel {
    
    private let endpointURL: URL?
    
    private var dataTuple: (episode: RMEpisode, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            // notificamos a nuestro delegado de la vista que ya puede leer datos de este modelo
            delegate?.didFetchEpisodeDetail()
        }
    }
    
    public weak var delegate: RMEpisodeDetailViewViewModelDelegate?
    
    //MARK: - Tipo de Seccion para la vista del detalle
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }
    
    // Variable pública pero solo para leer los datos
    public private(set) var episodeCellViewModel: [SectionType] = []
    
    //MARK: - Init
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
//        fetchEpisodeData()
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
                episode: episode,
                characters: characters
            )
        }
        
    }
    
    /// Crea las Cell a partir de la Tupla de Datos
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        // obtenemos los datos de la Tupla de datos
        let episodeInfo = dataTuple.episode
        let characters = dataTuple.characters
        
        // Formatear la fecha de Creación del Episodio
        var createdString = ""
        if let createdDate = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: episodeInfo.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortdateFormatter.string(from: createdDate)
        }
        
        
        episodeCellViewModel = [
            .information(viewModels: [
                .init(title: "Nombre del Episodio", value: episodeInfo.name),
                .init(title: "Fecha Emision", value: episodeInfo.air_date),
                .init(title: "Episodio", value: episodeInfo.episode),
                .init(title: "Creado", value: createdString)
            ]),
            .characters(viewModel: characters.compactMap({
                return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                              characterStatus: $0.status,
                                                              characterImage: URL(string: $0.image))
            }))
        ]
    }
    
}
