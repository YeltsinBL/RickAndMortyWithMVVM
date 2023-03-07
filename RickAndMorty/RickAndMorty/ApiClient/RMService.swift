//
//  RMService.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import Foundation

///Responsable de hacer las llamadas a la API
final class RMService {
    ///Instancia  de Singleton compartida
    static let shared = RMService()
    
    ///Hacemos el INIT privado para que utilice la instancia Shared
    private init() {}
    
    /// Llamar a la API de Rick and Morty
    /// - Parámetros:
    ///     - request: instancia de solicitud
    ///     - type: tipo de objeto que se espera obtener
    ///     - completion: devolución de la llamada con datos o error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void){
        
    }
}
