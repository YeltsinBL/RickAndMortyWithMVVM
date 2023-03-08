//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import UIKit

final class RMCharacterListViewViewModel: NSObject {

    private var characters: [RMCharacter] = [] {
        didSet {
          // Cada ves que se asigna los personajes, formateamos los datos al modelo de la celda del ViewModel
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImage: URL(string: character.image)
                )
                cellViewModels.append(viewModel)
            }
        }
    }
    
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    
    /// Buscar todos los personajes
    func fetchCharacters(){
        RMService.shared.execute(
            .listCharactersRequest,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self]  result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                self?.characters = results

            case .failure(let failure):
                print(String(describing: failure))
            }
        }
        
    }
}

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Devolvemos cuantas celdas mostramos
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? RMCharacterCollectionViewCell else {
            fatalError("Celda no compatible")
        }
        // Pasamos los datos del ViewModel de la posición dada del Collection
        cell.configure(with: cellViewModels[indexPath.row])
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
