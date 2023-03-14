//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import Foundation

final class RMEpisodeDetailViewViewModel {
    
    private let endpointURL: URL?
    
    //MARK: - Init
    
    init(endpointURL: URL?) {
        self.endpointURL = endpointURL
        fetchEpisodeData()
    }
    
    
    //MARK: - Func
    
    /// Buscar la información del episodio
    private func fetchEpisodeData() {
        guard let url = endpointURL,
        let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                print("Datos: \(String(describing: success))")
            case .failure:
                break
            }
        }
    }
    
}
