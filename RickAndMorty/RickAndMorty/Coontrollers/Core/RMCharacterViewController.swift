//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 6/03/23.
//

import UIKit

/// Controlador para mostrar y buscar Personajes
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground //el color del systema: oscuro o claro
        title = "Personajes"
        
        RMService.shared.execute(.listCharactersRequest,
                                 expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let success):
                print("Total: \(success.info.count)")
                print("Cuenta de resultados de paginas: \(success.results.count)")
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }

}
