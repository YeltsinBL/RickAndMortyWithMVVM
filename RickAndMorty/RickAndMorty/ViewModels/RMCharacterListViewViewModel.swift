//
//  CharacterListViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 7/03/23.
//

import UIKit

protocol RMCharacterListViewViewModelDelegate: AnyObject {
    /// Para que la Vista de Colección cargue los personajes iniciales
    func didLoadInitialCharacters()
    /// Para que se cargue los demás personajes de acuerdo a su ruta de índice
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])

}

/// ViewModel para manejar la lógica del RMCharacterListView
final class RMCharacterListViewViewModel: NSObject {

    // Se crea una referencia débil para no hacer que retenga el puntero de memoria cíclica y fuga de memoria
    public weak var delegate: RMCharacterListViewViewModelDelegate?
    
    // Para saber si se está cargando más Personajes
    private var isLoadingMoreCharacters = false
    
    // Almacenamos todos los personajes y verificamos si existen duplicados
    private var characters: [RMCharacter] = [] {
        didSet {
            // Cada ves que se asigna los personajes, formateamos los datos al modelo de la celda del ViewModel
            for character in characters {
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImage: URL(string: character.image)
                )
                // si el CellModelViews no contiene el nuevo ViewModel, debe de agregarlo
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
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
                    // Llamamos a la función del protocolo para cargar los personajes
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    //MARK: - Lógica para mostrar personajes adicionales
    
    /// Buscar si se necesitan los personajes adicionales
    public func fetchAdditionalCharacters(url: URL) {
        // Para que busque sólo cuando sea False
        guard !isLoadingMoreCharacters else {
            return
        }
        // Para que busque sólo cuando se esta al final del Collection
        isLoadingMoreCharacters = true
        // creamos una solicitud
        guard let request =  RMRequest(url: url) else {
            // Si fallamos en crear una Solicitud
            isLoadingMoreCharacters = false
            print("Creación de solicitud fallida")
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            // Creamos una referencia fuerte para quitar los self nulos
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let responseModel):
                // Obtenemos los nuevos datos básicos e información
                let moreResults = responseModel.results
                let info = responseModel.info
                // Almacenamos para saber la siguiente URL y obtener más datos
                strongSelf.apiInfo = info
                // Conjunto inicial de personajes
                let originalCount = strongSelf.characters.count
                // Conteo de los nuevos personajes
                let newCount = moreResults.count
                // Total de los conteos
                let total = originalCount + newCount
                // obtenemos el índice: el total de todas las busquedas - nueva busqueda actual
                let startingIndex = total - newCount
                // Creamos la matriz para el IndexPath
                let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount))
                    .compactMap {
                        return IndexPath(row: $0, section: 0)
                    }
                // Agregamos los nuevos personajes en una colección de datos
                strongSelf.characters.append(contentsOf: moreResults)
                // Activará la actualización de la Vista en el hilo principal
                DispatchQueue.main.async {
                    // Llamamos a la función del protocolo para actualizar los personajes
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print("Fallo: \(String(describing: failure))")
                strongSelf.isLoadingMoreCharacters = false
            }
        }
    }
    /// Mostrar el cargando en la parte final del CollectionView
    public var shouldShowLoadMoreIndicator: Bool {
        // saber si existe mas información
        return apiInfo?.next != nil
    }
    
}

//MARK: - Implementación del CollectionView

extension RMCharacterListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    // MARK: - Func DataSource - Almacenar los datos en el Collection
    
    /// Cantidad de elementos en el Collection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Devolvemos cuantas celdas mostramos
        return cellViewModels.count
    }
    
    /// Agregar los datos del ViewModel a las celdas
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
    
    /// Agregar el Spinner en el Footer del Collection
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
    
    // MARK: - Func DelegateFlowLayout - Especificar tamaños
    
    /// Tamaño de las celdas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Obtener el tamaño del dispositivo
        let bound = UIScreen.main.bounds
        // Especificar el Tamaño de las celdas
        let width = (bound.width-30)/2
        return CGSize(width: width, height: width * 1.5)
    }
    
    /// Tamaño del Footer
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
    
    /// Saber si hicimos Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Mostrar el indicador de carga
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters, // indica si está o no cargando
              !cellViewModels.isEmpty, // verificamos si la 'cellViewModels' no es vacio
              let nextUrlString = apiInfo?.next, // obtenemos la siguiente URLString
              let url = URL(string: nextUrlString) // convertirno la URLString a URL
        else {
            return
        }
        
        // retrasamos la acción por 2 segundos
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            // Obtenemos los puntos del desplazamiento en Y
            let offSet = scrollView.contentOffset.y
            // obtener la altura total
            let totalContentHeight = scrollView.contentSize.height
            // obtener la altura real del marco de la vista de desplazamiento
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            // Saber si estamos en la parte inferior del Collection:
            // restamos la altura total - altura real del marco - la altura que tiene el Footer
            if offSet >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                // Buscar mas personajes si se llego al final del Collection
                self?.fetchAdditionalCharacters(url: url)
            }
            // limpiamos el Timer
            t.invalidate()
        }
        
    }
}
