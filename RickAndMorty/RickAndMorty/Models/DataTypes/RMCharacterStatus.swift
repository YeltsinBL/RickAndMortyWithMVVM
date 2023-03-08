//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
    
    
    /// Convertimos los datos aquí porque no esta vinculados al esquema del Json de la API
    var text: String {
        switch self {
        case .alive, .dead :
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
    
}
