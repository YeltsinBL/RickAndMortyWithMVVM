//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

///Objeto que representa una llamada a la API y procesar los datos
final class RMRequest {
    /// Constante de API - URL Base
    private struct Constants {
        static let baseUrl = "https://rickandmortyapi.com/api"
    }
    /// Partes Finales - Listado
    private let endPoint: RMEndpoint
    /// Ruta de Componentes - Buscar por Id
    private let pathComponents: [String]
    /// Parámetros de consultas
    private let queryParameters: [URLQueryItem]
    
    /// Construir nuestra cadena de URL para la Solicitud API
    private var urlString: String {
        var string = Constants.baseUrl
        string += "/"
        string += endPoint.rawValue
        
        // Verificamos si esta vacío o no la ruta de componentes
        if !pathComponents.isEmpty {
            pathComponents.forEach {
                // Agregamos a la ruta el valor
                string += "/\($0)"
            }
        }
        // Verificamos si esta vacío o no los parámetros de consulta
        if !queryParameters.isEmpty {
            string += "?"
            // Creamos una cadena de argumentos para darle el formato de consulta
            let argumentString = queryParameters.compactMap {
                // Recorremos los datos y lo adaptamos a la URL
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }
            // Unimos los string con este separador
            .joined(separator: "&")
            
            string += argumentString
        }
        
        return string
    }
    
    ///  URL de la Api construida y calculada
    public var url: URL? {
        return URL(string: urlString)
    }
    
    /// Método HTTP
    public let httpMethod = "GET"
    
    /// Solicitud de Construcción
    /// - Parámetros:
    ///   - endPoint: Punto Final Objetivo
    ///   - pathComponents: Colección de componentes de Ruta
    ///   - queryParameters: Colección de parametros de consulta
    public init(endPoint: RMEndpoint,
                pathComponents: [String] = [],
                queryParameters: [URLQueryItem] = []) {
        self.endPoint = endPoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

}

//crear solicitudes mas simples
extension RMRequest {
    static let listCharactersRequest = RMRequest(endPoint: .character)
}
