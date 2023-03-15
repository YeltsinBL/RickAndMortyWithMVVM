//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 10/03/23.
//

import UIKit

/// Representacion de un episodio
protocol RMEpisodeDataRender {
    var name: String {get}
    var air_date: String {get}
    var episode: String {get}
}


final class RMCharacterEpisodeCollectionViewCellViewModel: Hashable, Equatable {
    
    private let episodeDataUrl: URL?
    
    private var isFetching = false
    
    private var dataBlock: ((RMEpisodeDataRender) -> Void)?
    
    /// Color para el borde de la cell
    public let borderColor: UIColor
    
    /// Almacena el modelo del Episodio de la API
    private var episode: RMEpisode? {
        // Iniciara tan pronto se le asigne algo
        didSet {
            guard let model = episode else { return  }
            // pasamos el modelo al dataBlock
            dataBlock?(model)
        }
    }
    
    //MARK: - Init
    
    /// Inicializador del RMCharacterEpisodeCollectionViewCellViewModel
    /// - Parameters:
    ///   - episodeDataUrl: URL para bascar la información de los episodios
    ///   - borderColor: asignar un color al borde de las celdas opcional
    init(episodeDataUrl: URL?, borderColor: UIColor = .systemBlue) {
        self.episodeDataUrl = episodeDataUrl
        self.borderColor = borderColor
    }
    
    //MARK: - Func
    
    /* Uso del patrón Published y Subscriber
     Cuando nos registramos recuperamos el protocolo en vez del modelo, asi solo obtenemos las propiedas indicadas en protocolo y no todas las del modelo
     */
    public func registerForData(_ block:@escaping (RMEpisodeDataRender) -> Void) {
        self.dataBlock =  block
    }
    
    
    /// Buscar episodio
    public func fetchEpisode() {
        guard !isFetching else {
            // Validar si ya se obtuvo los episodios anteriormente
            if let model = episode {
                self.dataBlock?(model)
            }
            return
        }
        
        guard let url = episodeDataUrl,
              let request = RMRequest(url: url)
        else { return }
        
        isFetching = true
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { [weak self] result in
            switch result {
            case .success(let model):
                DispatchQueue.main.async {
                    self?.episode = model
                }
            case .failure(let failure):
                print(String(describing: failure.localizedDescription))
            }
        }
        
    }

    
    //MARK: - Func Hashable - Equatable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.episodeDataUrl?.absoluteString ?? "")
    }
    static func == (lhs: RMCharacterEpisodeCollectionViewCellViewModel,
                    rhs: RMCharacterEpisodeCollectionViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
}
