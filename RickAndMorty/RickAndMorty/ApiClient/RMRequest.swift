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
    let endPoint: RMEndpoint
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
    public var endUrl: URL? {
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
    
    /// Inicializador conveniencia opcional para adaptar la URL al init principal
    /// - Parameter url: URL para analizar y adaptarla al init principal
    convenience init?(url: URL) {
        let string = url.absoluteString // obtenemos el string de la URL
        // Verificamos si el String contiene la Url base
        if !string.contains(Constants.baseUrl) {
            return nil
        }
        // recortamos el String
        let trimmed = string.replacingOccurrences(of: Constants.baseUrl+"/", with: "")
        // analizamos el String recortado
        if trimmed.contains("/") {
            // separamos el string por el '/'
            let components = trimmed.components(separatedBy: "/")
            // Verificamos si no está vacío
            if !components.isEmpty {
                // obtenemos el primer elemento
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    // Agregamos todos los componentes separados
                    pathComponents = components
                    // Eliminamos el primer componente que es el EndpointString
                    pathComponents.removeFirst()
                }
                // comparamos si existe ese elemento en nuestro Endpoint
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endPoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        } else if trimmed.contains("?") {
            // separamos el string por el '?'
            let components = trimmed.components(separatedBy: "?")
            // Verificamos si no está vacío
            if !components.isEmpty, components.count >= 2 {
                // obtenemos el primer elemento que debe ser el Endpoint
                let endpointString = components[0]
                // obtenemos las queryItems de tipo String
                let queryItemsString = components[1]
                // convertimos los queryItemsString al formato de URLQueryItem
                let queryItems: [URLQueryItem] = queryItemsString
                    .components(separatedBy: "&")
                    .compactMap {
                        // verificamos si el valor contiene el signo '='
                        guard $0.contains("=") else {
                            return nil
                        }
                        //separamos el valor actual por el '='
                        let part = $0.components(separatedBy: "=")
                        
                        return URLQueryItem(name: part[0], value: part[1])
                    }
                // Verificamos si el EndpointString existe en el RMEndpoint para continuar
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endPoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
        
    }
    
}

//crear solicitudes mas simples
extension RMRequest {
    static let listCharactersRequest = RMRequest(endPoint: .character)
}
