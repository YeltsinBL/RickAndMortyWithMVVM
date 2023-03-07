//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import Foundation

final class RMCharacterCollectionViewCellViewModel {
    
     public let characterName: String
     private let characterStatus: RMCharacterStatus
     private let characterImage: URL?
    
    // MARK: - Init
    
    init(characterName: String,
         characterStatus: RMCharacterStatus,
         characterImage: URL?
    ) {
        self.characterName = characterName
        self.characterStatus = characterStatus
        self.characterImage = characterImage
    }
    
    public var characterStatusText: String {
        return characterStatus.rawValue
    }
    
    // MARK: - Func
    
    /// Buscar la imágen
    /// - Parameter completion: devuelve la data de la imágen o un error
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Resúmen del administrador de imágenes
        guard let url = characterImage else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            completion(.success(data))
        }
        task.resume()
        
    }
    
}
