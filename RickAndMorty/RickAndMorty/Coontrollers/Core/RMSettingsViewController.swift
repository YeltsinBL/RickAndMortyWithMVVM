//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit
import SwiftUI
import SafariServices
import StoreKit

/// Controlador para mostrar varias opciones y configuraciones de la aplicación
final class RMSettingsViewController: UIViewController {
    
    // Propiedad para almacenar la vista de SwiftUI
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Configuración"
        
        addSwiftUIController()
    }
    
    
    private func addSwiftUIController() {
        // Instanciamos la vista de SwiftUI dentro de un UIHostingController para poder utilizar su vista
        let settingsSwiftUIController = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModels: RMSettingsOption.allCases.compactMap({
                        return RMSettingsCellViewModel(type: $0) { [weak self] option in
                            self?.handlerTap(option: option)
                        }
                    })
                )
            )
        )

        
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
        
        self.settingsSwiftUIController = settingsSwiftUIController
    }
    
    private func handlerTap(option: RMSettingsOption) {
        // Aseguramos de hacer estas acciones en el hilo principal
        guard Thread.current.isMainThread else {
            return
        }
        if let url = option.targetUrl {
            // Abrir Safari dentro de la Aplicación
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        } else if option == .rateApp {
            // Mostrar indicador de calificación
            if let windosScene = self.view.window?.windowScene {
                SKStoreReviewController.requestReview(in: windosScene)
            }
        }
    }
    
}
