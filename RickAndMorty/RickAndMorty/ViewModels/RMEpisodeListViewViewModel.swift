//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by YeltsinMacPro13 on 14/03/23.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate: AnyObject {
    /// Para que la Vista de Colección cargue los episodios iniciales
    func didLoadInitialEpisodes()
    /// Para que se cargue los demás episodios de acuerdo a su ruta de índice
    /// - Parameter newIndexPaths: Matriz de la cantidad de los nuevos índices agregados
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    /// Notificar a la View que se ha seleccionado un episodio
    /// - Parameter episode: Modelo del episodio seleccionado
    func didSelectEpisode(_ episode: RMEpisode)

}

/// ViewModel para manejar la lógica del RMEpisodeListView
final class RMEpisodeListViewViewModel: NSObject {

    // Se crea una referencia débil para no hacer que retenga el puntero de memoria cíclica y fuga de memoria
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    // Para saber si se está cargando más Episodios
    private var isLoadingMoreEpisodes = false
    
    // Almacenamos todos los episodios y verificamos si existen duplicados
    private var episodes: [RMEpisode] = [] {
        didSet {
            // Cada ves que se asigna los episodios, formateamos los datos al modelo de la celda del ViewModel
            for episode in episodes {
                //Reutilizamos el ViewModel de los episodios del los personajes
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string: episode.url))
                
                // si el CellModelViews no contiene el nuevo ViewModel, debe de agregarlo
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }
    
    /// Colección para agregar los episodios cuando se actualicen los datos, reutilizamos el mismo que muestra los episodios en el detalle del personaje
    private var cellViewModels: [RMCharacterEpisodeCollectionViewCellViewModel] = []
    /// Almacenar la información del estado de los datos para la paginación
    private var apiInfo: RMGetAllEpisodesResponse.Info? = nil
    
    /// Buscar  los episodios iniciales (20)
    public func fetchEpisodes(){
        RMService.shared.execute(
            .listEpisodesRequest,
            expecting: RMGetAllEpisodesResponse.self
        ) { [weak self]  result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                // Guardamos los episodios en una colección de datos
                self?.episodes = results
                // Almacenamos para saber la siguiente URL y obtener más datos
                self?.apiInfo = info
                // Activará la actualización de la Vista en el hilo principal
                DispatchQueue.main.async {
                    // Llamamos a la función del protocolo para cargar los episodios
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
    //MARK: - Lógica para mostrar episodios adicionales
    
    /// Buscar si se necesitan los episodios adicionales
    public func fetchAdditionalEpisodes(url: URL) {
        // Para que busque sólo cuando sea False
        guard !isLoadingMoreEpisodes else {
            return
        }
        // Para que busque sólo cuando se esta al final del Collection
        isLoadingMoreEpisodes = true
        // creamos una solicitud
        guard let request =  RMRequest(url: url) else {
            // Si fallamos en crear una Solicitud
            isLoadingMoreEpisodes = false
            print("Creación de solicitud fallida")
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
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
                let originalCount = strongSelf.episodes.count
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
                strongSelf.episodes.append(contentsOf: moreResults)
                // Activará la actualización de la Vista en el hilo principal
                DispatchQueue.main.async {
                    // Llamamos a la función del protocolo para actualizar los personajes
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreEpisodes = false
                }
            case .failure(let failure):
                print("Fallo: \(String(describing: failure))")
                strongSelf.isLoadingMoreEpisodes = false
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

extension RMEpisodeListViewViewModel: UICollectionViewDataSource, UICollectionViewDelegate,
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
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifer,
            for: indexPath
        ) as? RMCharacterEpisodeCollectionViewCell else {
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
    
    // MARK: - Func Delegate - Acciones en la Cell
    
    /// Acción de seleccionar una celda
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Quitamos el resaltado al seleccionar
        collectionView.deselectItem(at: indexPath, animated: true)
        // Obtener el modelo de la cell que a sido seleccionada usando la ruta del indice
        let episode = episodes[indexPath.row]
        // Pasamos el modelo seleccionado
        delegate?.didSelectEpisode(episode)
    }
    
    // MARK: - Func DelegateFlowLayout - Especificar tamaños
    
    /// Tamaño de las celdas
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Obtener el tamaño del dispositivo
        let bound = UIScreen.main.bounds
        // Especificar el Tamaño de las celdas
        let width = (bound.width-30)/2
        return CGSize(width: width, height: width * 0.8)
    }
    
    /// Tamaño del Footer
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        // si ya no hay datos para cargar, pone el tamaño del pie de página en cero
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
    
}

//MARK: - ScrollView
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    
    /// Saber si hicimos Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Mostrar el indicador de carga
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes, // indica si está o no cargando
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
                // Buscar más episodios si se llego al final del Collection
                self?.fetchAdditionalEpisodes(url: url)
            }
            // limpiamos el Timer
            t.invalidate()
        }
        
    }
}

