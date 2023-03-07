//
//  RMLocationViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Agregamos el final para que no se pueda subclasificar ni hacer herencia
final class RMLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Localización"
    }
    
}
