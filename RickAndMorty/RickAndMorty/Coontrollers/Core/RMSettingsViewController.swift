//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit
import SwiftUI

/// Controlador para mostrar varias opciones y configuraciones de la aplicación
final class RMSettingsViewController: UIViewController {

    // Obtenemos todos los modelos de los tipos de configuracion
    private let settingsViewViewModel = RMSettingsViewViewModel(
        cellViewModels: RMSettingsOption.allCases.compactMap({
            return RMSettingsCellViewModel(type: $0)
        })
    )
    
    // Instanciamos la vista de SwiftUI dentro de un UIHostingController para poder utilizar su vista
    private let settingsSwiftUIController = UIHostingController(
        rootView: RMSettingsView(
            viewModel: RMSettingsViewViewModel(
                cellViewModels: RMSettingsOption.allCases.compactMap({
                    return RMSettingsCellViewModel(type: $0)
                })
            )
        )
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Configuración"
        
        addSwiftUIController()
    }
    
    
    func addSwiftUIController() {
        // Agregar como Hijo el SwiftUI al ViewController
        addChild(settingsSwiftUIController)
        // Informar que se movió el SwiftUI al padre ViewController
        settingsSwiftUIController.didMove(toParent: self)
        // Agregamos la vista del SwiftUI al controller como subVista
        guard let settingsSwiftUIControllerView = settingsSwiftUIController.view else { return }
        view.addCustomSubViews(settingsSwiftUIControllerView)
        //Configuramos los constraints
        settingsSwiftUIControllerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            settingsSwiftUIControllerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            settingsSwiftUIControllerView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            settingsSwiftUIControllerView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            settingsSwiftUIControllerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
}
