//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 9/03/23.
//

import Foundation

/// Recibe y envía los datos del personaje seleccionado para mostrar más información
final class RMCharacterDetailViewViewModel {
    
    /// Tipos de secciones para personalizar el CollectionViewCompositionalLayout
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    /// Almacena todos los tipos de secciones para personalizar el CollectionViewCompositionalLayout
    public let sections = SectionType.allCases
    
    private let charater: RMCharacter
    
//    private var requestUrl: URL? {
//        return URL(string: charater.url)
//    }
    
    public var title: String {
        charater.name.uppercased()
    }
    
    // MARK: - Init
    
    init(character : RMCharacter) {
        self.charater = character
    }
    
}
