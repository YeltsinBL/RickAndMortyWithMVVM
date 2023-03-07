//
//  Extensions.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import UIKit

extension UIView {
    
    /// Agregar subvistas personalizadas
    /// - Parameter view: acepta todas la vistas
    func addCustomSubViews(_ view: UIView...) {
        view.forEach {
            addSubview($0)
        }
    }
}
