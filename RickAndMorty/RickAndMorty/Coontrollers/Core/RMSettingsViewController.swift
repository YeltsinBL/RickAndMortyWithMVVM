//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Controlador para mostrar varias opciones y configuraciones de la aplicación
final class RMSettingsViewController: UIViewController {

    // Obtenemos todos los modelos de los tipos de configuracion
    private let settingsViewViewModel = RMSettingsViewViewModel(
        cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0)
        })
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Configuración"
    }
    
}
