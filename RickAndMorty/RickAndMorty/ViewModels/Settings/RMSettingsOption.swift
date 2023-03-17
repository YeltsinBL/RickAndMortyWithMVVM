//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 17/03/23.
//

import UIKit

/// Todos los casos para la configuracón
enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode
    
    /// Título de acuerdo al caso
    var displayTitle: String {
        switch self {
        case .rateApp:
            return "Calificar aplicación"
        case .contactUs:
            return "Contáctanos"
        case .terms:
            return "Términos"
        case .privacy:
            return "Privacidad"
        case .apiReference:
            return "Referencia del API"
        case .viewSeries:
            return "Serie de videos"
        case .viewCode:
            return "Código de la Aplicación"
        }
    }
    
    /// Icono de acuerdo al caso
    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            return UIImage(systemName: "star.fill")
        case .contactUs:
            return UIImage(systemName: "paperplane")
        case .terms:
            return UIImage(systemName: "doc")
        case .privacy:
            return UIImage(systemName: "lock")
        case .apiReference:
            return UIImage(systemName: "list.clipboard")
        case .viewSeries:
            return UIImage(systemName: "tv.fill")
        case .viewCode:
            return UIImage(systemName: "hammer.fill")
        }
    }
    
    /// Color del contenedor del ícono de acuerdo al caso
    var iconCantainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemRed
        case .contactUs:
            return .systemBlue
        case .terms:
            return .systemBrown
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemMint
        case .viewSeries:
            return .systemIndigo
        case .viewCode:
            return .systemGreen
        }
    }
}
