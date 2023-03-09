//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 9/03/23.
//

import Foundation

/// Recibe y envía los datos del personaje seleccionado para mostrar más información
final class RMCharacterDetailViewViewModel {
    
    private let charater: RMCharacter
    
    init(character : RMCharacter) {
        self.charater = character
    }
    
    public var title: String {
        charater.name.uppercased()
    }
}
