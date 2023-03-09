//
//  RMCharacterCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import Foundation

// Hashable: obtener el valor unico del Hash
// Equatable: permite la ecuación del objeto si dos cosas son iguales entre si
final class RMCharacterCollectionViewCellViewModel: Hashable, Equatable {
    
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
        return "Estado: \(characterStatus.text)"
    }
    
    // MARK: - Func
    
    /// Buscar la imágen
    /// - Parameter completion: devuelve la data de la imágen o un error
    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        // TODO: Abstraer al administrador de imágenes
        guard let url = characterImage else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Utilizamos el cargador de imágenes dedicado
        RMImageLoader.shared.downloadImage(url, completion: completion)
        
    }
    
    //MARK: - Hashable
    /**Creamos una forma más inteligente de verificar si el CollectionViewModel contienes los nuevos datos para evitar crear de manera redundante  el mismo ViewModel**/
    static func == (lhs: RMCharacterCollectionViewCellViewModel, rhs: RMCharacterCollectionViewCellViewModel) -> Bool {
        // verificamos si los hash son iguales
        return lhs.hashValue == rhs.hashValue
    }
    // Cada vez que se crea el ViewModel, obtener el valor único del Hash y saber si existe en la matriz
    func hash(into hasher: inout Hasher) {
        hasher.combine(characterName)
        hasher.combine(characterStatus)
        hasher.combine(characterImage)
    }
    
    
}
