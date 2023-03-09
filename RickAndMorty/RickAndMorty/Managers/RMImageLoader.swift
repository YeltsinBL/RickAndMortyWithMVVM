//
//  RMImageLoader.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 8/03/23.
//

import Foundation

final class RMImageLoader {
    // Accedemos al RMImageLoader a traves de Singleton
    static let shared = RMImageLoader()
    
    // Instanciamos el uso del Cacheque que guarda: Tipo de Clave y Tipo de Clase
    private var imageDataCache = NSCache<NSString, NSData>()
    // MARK: - Init
    
    private init() {}
    
    // MARK: - Func
    
    
    /// Cargar las imágenes usando el almacenamiento en cache de imágenes en memoria para evitar cargarlas desde la URL  cuando ya se ha hecho anteriormente
    /// - Parameter url: URL para obtener las imágenes
    /// - Parameter completion: Devolucion de la data de la URL
    public func downloadImage(_ url: URL, completion:@escaping (Result<Data, Error>) -> Void) {
        // Indicamos que los datos dentro de aquí serán de nuestra memoria cache de datos de imágenes
        
        let key = url.absoluteString as NSString
        
        // Verificamos si la clave existe en cache para devolverla directamente o la almacenamos
        if let data = imageDataCache.object(forKey: key) {
            print("Leyendo desde la cache \(key)")
            completion(.success(data as Data)) //NSData == Data || NSString == String
            return
        }
        
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            // Almacenar en cache los datos que obtenemos
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            print("Agregando al cache: \(key)")
            completion(.success(data))
        }
        task.resume()
    }
    
}
