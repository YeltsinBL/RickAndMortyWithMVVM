//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 9/03/23.
//

import UIKit

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
    
    // MARK: - Section Layout
    
    
    /// Crea el diseño de la sección de la foto
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    public func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento(celda) de diseño de colección con un tamaño
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0), //Ocupa todo el ancho del grupo
                heightDimension: .fractionalHeight(1.0)//Ocupa toda la altura del grupo
            )
        )
        // Mostrar los espacios entre las items
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: 0,
                                                     bottom: 10,
                                                     trailing: 0)
        
        // Instanciamos un Grupo de diseño de colección en vertical (el bloque de las celdas)
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0), //Ocupa todo el ancho de la vista
                heightDimension: .fractionalHeight(0.5)//Ocupa la mitad de la altura de la vista
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    /// Crea el diseño de la sección de la información
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    public func createInformationSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento de diseño de colección con un tamaño
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(0.5),//Ocupa la mitad del ancho del grupo
                heightDimension: .fractionalHeight(1.0)//Ocupa toda la altura del grupo
            )
        )
        // Mostrar los espacios entre las items
        item.contentInsets = NSDirectionalEdgeInsets(top: 2,
                                                     leading: 2,
                                                     bottom: 2,
                                                     trailing: 2)
        
        // Instanciamos un Grupo de diseño de colección en horizontal
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(150)
            ),
            subitems: [item, item] // mostrar 2 elementos, uno a lado del otro
        )
        let section = NSCollectionLayoutSection(group: group)
        
        return section
    }

    /// Crea el diseño de la sección de los episodios
    /// - Returns: devuelve el CollectionViewCompositionalLayout
    public func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        
        // Instanciamos un elemento de diseño de colección con un tamaño
        let item = NSCollectionLayoutItem(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(1.0), //Ocupa todo el ancho del grupo
                heightDimension: .fractionalHeight(1.0)//Ocupa toda la altura del grupo
            )
        )
        // Mostrar los espacios entre las items
        item.contentInsets = NSDirectionalEdgeInsets(top: 10,
                                                     leading: 5,
                                                     bottom: 10,
                                                     trailing: 8)
        
        // Instanciamos un Grupo de diseño de colección en horizontal
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                // Especificamos las dimensiones
                widthDimension: .fractionalWidth(0.8), // ocupa casi todo el ancho de la vista
                heightDimension: .absolute(150) // tiene un valor por defecto para la altura
            ),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        // indicamos que esta seccion tiene un desplazamiento ortogonal
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }

    
}
