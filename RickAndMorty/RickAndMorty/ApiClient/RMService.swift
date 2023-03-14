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
    
    /// Instancia del Administrador en Cache de API
    private let cacheManager = RMAPICacheManager()
    
    ///Hacemos el INIT privado para que utilice la instancia Shared
    private init() {}
    
    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }
    
    
    /// Llamar a la API de Rick and Morty
    /// - Parámetros:
    ///     - request: instancia de solicitud
    ///     - type: tipo de objeto que se espera obtener
    ///     - completion: devolución de la llamada con datos o error
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void){
        
            // Verificar si existen los datos en el Caché
            if let cacheData = cacheManager.cachesResponse(for: request.endPoint, url: request.endUrl) {
                print("Uso de la respuesta API almacenada")
                // Decodificar la respuesta
                do {
                    // Devuelve un modelo apropiado de acuerdo a lo almacenado en caché
                    let result = try JSONDecoder().decode(type.self, from: cacheData)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
                return
            }
            
            guard let urlRequest = self.request(from: request) else {
                completion(.failure(RMServiceError.failedToCreateRequest))
                return
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(error ?? RMServiceError.failedToGetData))
                    return
                }
                
                // Decodificar la respuesta
                do {
                    // Devuelve un modelo apropiado de acuerdo al tipo que se le llame
                    let result = try JSONDecoder().decode(type.self, from: data)
                    // Almacenamos los datos en el caché
                    self?.cacheManager.setCaches(for: request.endPoint,
                                                 url: request.endUrl,
                                                 data: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            
    }
    
    
    /// Convertir la URL en una URLRequest
    /// - Parameter rmRequest: Obtenemos la URL
    /// - Returns: devuelve la URLRequest opcional
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.endUrl else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
    
}
