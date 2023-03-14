//
//  RMAPICacheManager.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 13/03/23.
//

import Foundation

/// Administrador en cachés de API con ámbito de sesión de memoria
final class RMAPICacheManager {
    
    
    /// Diccionario de Caché de acuerdo a los Endpoint
    private var cacheDictionary: [
        RMEndpoint: NSCache<NSString, NSData>
    ] = [:]
    
    
    //MARK: - Init
    
    init() {
        setUpCache()
    }
    
    //MARK: - Func Public
    
    /// Verificar si está disponible el Caché de acuerdo al tipo
    /// - Parameters:
    ///   - endpoint: Tipo de caché del Endpoint
    ///   - url: Es la clave que obtiene la información
    /// - Returns: retorna el dato o nada luego de la búsqueda
    public func cachesResponse(for endpoint: RMEndpoint, url: URL?) -> Data?{
        // Obtener el cache del destino
        guard let targetCache = cacheDictionary[endpoint],
            let url = url else { return nil }
        // Obtener el objeto con una clave particular
        let key = url.absoluteString as NSString // lo converimos en un objeto enlazado a una clase
        return targetCache.object(forKey: key) as? Data
    }
    
    /// Agrega  al Caché de acuerdo al tipo
    /// - Parameters:
    ///   - endpoint: Tipo de caché del Endpoint
    ///   - url: Es la clave que obtiene la información
    ///   - data: Datos que se van a guardar en el caché
    public func setCaches(for endpoint: RMEndpoint, url: URL?, data: Data) {
        // Obtener el cache del destino
        guard let targetCache = cacheDictionary[endpoint],
            let url = url else { return }
        // Obtener el objeto con una clave particular
        let key = url.absoluteString as NSString // lo converimos en un objeto enlazado a una clase
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    //MARK: - Func private
    
    /// Configuracion del Caché
    private func setUpCache(){
        // Recorremos el Endpoint
        RMEndpoint.allCases.forEach { endpoint in
            // Agregamos en el diccionario el endpoint y crea una nueva instancia
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        }
    }
}
