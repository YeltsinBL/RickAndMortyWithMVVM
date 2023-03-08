//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    /// Para que la Vista de Colección continúe deslizandose y cargue más datos
    func didLoadInitialCharacters()

}

/// ViewModel para manejar la logica del RMCharacterListView
final class RMCharacterListViewViewModel: NSObject {

    // Se crea una referencia débil para no hacer que retenga el puntero de memoria cíclica y fuga de memoria
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    // Para saber si se esta cargando más Personajes
    private var isLoadingMoreCharacters = false
    
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
    
    /// Colección para agregar los personajes cuando se actualicen los datos
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = []
    /// Almacenar la información del estado de los datos para la paginación
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    
    /// Buscar  los personajes iniciales (20)
    public func fetchCharacters(){
        RMService.shared.execute(
            .listCharactersRequest,
            expecting: RMGetAllCharactersResponse.self
        ) { [weak self]  result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                // Guardamos los personajes en una colección de datos
                self?.characters = results
                // Almacenamos para saber la siguiente URL y obtener más datos
                self?.apiInfo = info
                // Activará la actualización de la Vista en el hilo principal
                DispatchQueue.main.async {
                    // Llamamos a la función del protocolo para actualizar los personajes
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    //MARK: - Lógica para mostrar personajes adicionales
    
    /// Mostrar el cargando en la parte final del CollectionView
    public var shouldShowLoadMoreIndicator: Bool {
        // saber si existe mas información
        return apiInfo?.next != nil
    }
    
}

//MARK: - Implementacion del CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    // MARK: - Func Almacenar los datos en el Collection
    
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // Devolvemos la vista reutilizable que no sea nula
        guard kind == UICollectionView.elementKindSectionFooter,
              // Sacamos de la cola el pie de pagina
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.indentifier,
                for: indexPath
              ) as? RMFooterLoadingCollectionReusableView
        else {
            fatalError("Sin soporte")
        }
        footer.startAnimating()
        return footer
    }
    
    // MARK: - Func Especificar tamaños
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Obtener el tamaño del dispositivo
        let bound = UIScreen.main.bounds
        // Especificar el Tamaño de las celdas
        let width = (bound.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // si ya no hay datos para cargar, pone el tamaño del pie de pagina en cero
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}

//MARK: - ScrollView
extension RMCharacterListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Mostrar el indicador de carga
        guard shouldShowLoadMoreIndicator, !isLoadingMoreCharacters else {
            return
        }
        // Obtenemos los puntos del desplazamiento en Y
        let offSet = scrollView.contentOffset.y
        // obtener la altura total
        let totalContentHeight = scrollView.contentSize.height
        // obtener la altura real del marco de la vista de desplazamiento
        let totalScrollViewFixedHeight = scrollView.frame.size.height
        
        // Saber si estamos en la parte inferior del Collection:
        // restamos la altura total - altura real del marco - la altura que tiene el Footer
        if offSet >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
            print("Comenzar a buscar")
            isLoadingMoreCharacters = true
        }
        
    }
}
