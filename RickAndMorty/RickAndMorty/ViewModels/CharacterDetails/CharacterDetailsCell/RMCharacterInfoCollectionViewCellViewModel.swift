//
//  RMCharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 10/03/23.
//

import UIKit

final class RMCharacterInfoCollectionViewCellViewModel {
    
    private let type: TitleCell
    
    private let value: String
    
    
    // Inicializar las formateadores de fechas es costoso en rendimiento
    /// Formato de la fecha del API
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    /// Formatear la Fecha
    static let shortdateFormatter: DateFormatter = {
       // Formato
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
        formatter.dateFormat = "dd/MM/yyyy h:mm a"
        return formatter
    }()
    
    /// Nombre obtenido del TitleCell
    public var title: String {
        type.displayTitle
    }
    
    /// Valor de la Información
    public var displayValue: String {
        if value.isEmpty {return "Ninguno"}
        
        // Cambiar el estilo de la fecha
        if let date = Self.dateFormatter.date(from: value), type == .created {
            return Self.shortdateFormatter.string(from: date)
        }
        return value
    }
    
    /// Variable computada para obtener las iconos
    public var iconImage:UIImage? {
        return type.iconImage
    }
    
    /// Variable computada para obtener los colores de las iconos
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    /// Obtener el titulo de las Cell y diferenciar el icon
    enum TitleCell: String {
        case status
        case gender
        case type
        case species
        case origin
        case location
        case created
        case episodeCount
        
        /// Devuelve un color de acuerdo al caso
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemGray
            case .gender:
                return .systemBlue
            case .type:
                return .systemRed
            case .species:
                return .systemPurple
            case .origin:
                return .systemOrange
            case .location:
                return .systemPink
            case .created:
                return .systemYellow
            case .episodeCount:
                return .systemMint
            }
        }
        
        /// Devuelve un icon de acuerdo al caso
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "figure.stand")
            case .gender:
                return UIImage(systemName: "figure.dress.line.vertical.figure")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "person.fill.questionmark")
            case .origin:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "globe.americas")
            case .created:
                return UIImage(systemName: "calendar")
            case .episodeCount:
                return UIImage(systemName: "person.crop.rectangle.stack")
            }
        }
        
        /// Devuelve un nombre de acuerdo al caso
        var displayTitle: String {
            switch self {
            case .status,
                .gender,
                .type,
                .species,
                .origin,
                .created,
                .location:
                return rawValue.uppercased() // devuelve el mismo valor de los casos
            case .episodeCount:
                return "CANT. EPISODIOS"
            }
        }
        
    }
    
    init(type: TitleCell, value: String) {
        self.type = type
        self.value = value
    }
}
