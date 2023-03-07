//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

/// Representa puntos finales unicos de la API
@frozen enum RMEndpoint: String {
    /// Casos para obtener datos de los personajes
    case character
    /// Casos para obtener datos de la localizacion
    case location
    /// Casos para obtener datos de los episodios
    case episode
}

