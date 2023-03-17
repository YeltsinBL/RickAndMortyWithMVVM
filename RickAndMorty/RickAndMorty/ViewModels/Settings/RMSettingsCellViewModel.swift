//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 17/03/23.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
// Identifiable: Hacemos que tenga un identificador único por cada instancia que se realice
// Hashable: obtener el valor único del Hash
    let id = UUID()
    
    //MARK: - Property Private
    
    private let type: RMSettingsOption
    
    //MARK: - Property Public
    
    public var image: UIImage? {
        return type.iconImage
    }
    public var title: String {
        return type.displayTitle
    }
    public var iconCantainerColor: UIColor {
        return type.iconCantainerColor
    }
    
    //MARK: - Init
    
    init(type: RMSettingsOption) {
        self.type = type
    }
    
}
