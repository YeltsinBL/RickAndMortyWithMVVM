//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 17/03/23.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
// Identifiable: Hacemos que tenga un identificador único por cada instancia que se realice
    
    let id = UUID()
    
    //MARK: - Property Private
    //MARK: - Property Public
    
    
    public let type: RMSettingsOption
    
    public let onTapHandler: (RMSettingsOption) -> Void
    
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
    
    init(type: RMSettingsOption, onTapHandler:@escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
    
}
