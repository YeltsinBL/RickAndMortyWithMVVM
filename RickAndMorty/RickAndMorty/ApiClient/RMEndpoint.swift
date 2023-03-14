//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

/// Representa puntos finales unicos de la API
@frozen enum RMEndpoint: String, CaseIterable, Hashable {
// Uso del CaseIterable para hacer un bucle sobre los tres casos
// Uso del Hashable para obtener un valor diferencia de cada caso
    /// Casos para obtener datos de los personajes
    case character
    /// Casos para obtener datos de la ubicación
    case location
    /// Casos para obtener datos de los episodios
    case episode
}

