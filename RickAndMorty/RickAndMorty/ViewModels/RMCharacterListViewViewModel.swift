//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import UIKit

final class RMCharacterListViewViewModel: NSObject {
    
    /// Buscar todos los personajes
    func fetchCharacters(){
        RMService.shared.execute(.listCharactersRequest,
                                 expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let success):
                print("Ejemplo de URL imagen: \(String(success.results.first?.image ?? "Sin imagen"))")
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Celda no compatible")
        }
        
        let viewModel = RMCharacterCollectionViewCellViewModel(
            characterName: "Swift",
            characterStatus: .alive,
            characterImage: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")
        )
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Obtener el tamaño del dispositivo
        let bound = UIScreen.main.bounds
        // Especificar el Tamaño de las celdas
        let width = (bound.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
}
