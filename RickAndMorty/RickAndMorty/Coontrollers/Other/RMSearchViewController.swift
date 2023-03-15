//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import UIKit

/// Controlador para configurar las búsquedas
final class RMSearchViewController: UIViewController {

    /// estructura de adhesion correcta
    struct Config {
        /// Tipo de configuración - listados
        enum Types {
            case character
            case episode
            case location
        }
        /// Almacena todos los tipos de configuración - listados
        let types: Types
    }
    
    private let config: Config
    
    //MARK: - Init
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Buscar"
        view.backgroundColor = .systemBackground
    }
    

}
