//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 10/03/23.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: TitleCell
    
    public let value: String
    
    /// Nombre obtenido del TitleCell
    public var title: String {
        self.type.displayTitle
    }
    
    
    /// Obtener el titulo de las Cell y diferenciar el icon
    enum TitleCell {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        /// Devuelve un nombre de acuerdo al caso
        var displayTitle: String {
            switch self {
            case .status:
                return "Estado"
            case .gender:
                return "Genero"
            case .type:
                return "Tipo"
            case .species:
                return "Especie"
            case .origin:
                return "Origen"
            case .location:
                return "Ubicacion"
            case .created:
                return "Creado"
            case .episodeCount:
                return "Cant. de Episodios"
            }
        }
        
    }
    
    init(type: TitleCell, value: String) {
        self.type = type
        self.value = value
    }
}
