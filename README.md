# Rick And Morty With MVVM In Xcode
## _Aplicación iOS usando la api de Rick and Morty con la arquitectura MVVM._

### Configuración y estructura del proyecto
Eliminamos el 'Main.storyboard' porque todo se hára por código.

Se crearon las siguientes carpetas para organizar los archivos:
- Controllers: para tener todos los controllers de las vistas.
-- Core: contendrá los archivos del controller de las vistas.
- Models: todos los tipos de datos.
- Views: todas las vistas UI.
- ViewModels: las conexiones de los models con los controllers, agregar la lógica del negocio para el controller.
- ApiClient: las llamadas HTTP para consumir las apis.
- Managers: todo lo que no esté relacionado con la Api.
- Resources: aquí irá todo lo que no esté dentro de las otras carpetas.

### Explicación de lo realizado

En `Controller -> Core`:
- RMTabViewController: es la vista principal, que se le agrego los demás controller como un 'navigationItem’.
-- RMCharacterViewController: para visualizar todos los personajes y navegar a la vista del detalle cuando se selecciona un personaje.
-- RMEpisodeViewController: para visualizar los episodios.
-- RMLocationViewController: para visualizar las ubicaciones.
-- RMSettingsViewController: para realizar configuraciones dentro de la aplicación.

En `Controller -> Other`:
- RMCharacterDetailViewController: controller para mostrar la vista del detalle del personaje seleccionado.
-- Navega hacia el detalle del episodio del personaje seleccionado.
- RMEpisodeDetailViewController: controller para visualizar el detalle del episodio seleccionado.
-- Para mostrar los datos del detalle del espisodio, el delegate de este ViewModel notifica que ya se obtuvo los datos.
-- Navega hacia el detalle del personaje del episodio seleccionado.

En `Models`:
- Se creó dos carpetas para diferencia los modelos:
-- APIResponseTypes: para mapear el Json que se recibe de acuerdo al tipo de objeto.
-- DataTypes: son los tipos de datos separados.

En `Views`:
- `RMFooterLoadingCollectionReusableView`: esta es una vista reusable. Se creo y configuro el 'spinner' que se mostrará al final del 'Collection'.
- Para el listado de los personajes `Views -> Character`:
-- `RMCharacterListView`: es la lista donde se muestra los personajes, aquí se agregó un 'spinner' para indicar que se está cargando para mostrar los personajes iniciales y un 'collection' donde se registra la 'cell' y el 'spinner'; y se agrego el protocolo 'Delegate' del ViewModel.
-- Se creó el protocolo 'Delegate' de esta vista para notificar a su controller que se ha seleccionado un personaje para mostrar su detalle.
-- `RMCharacterCollectionViewCell`: aquí se crean y configuran los elementos que contendrá cada cell y se los relaciona con los datos que llega del ViewModel.
- Para el detalle de los personajes `Views -> CharacterDetails`:
-- `RMCharacterDetailView`: vista donde se mostrará la información detallada del personaje seleccionado.
-- Se registran las Cell por las secciones y sus cantidades.
-- `CharacterDetailsCells > RMCharacterPhotoCollectionViewCell`: vista de la primera sección del detalle, aquí solo se muestra la imagen del personaje seleccionado.
-- `CharacterDetailsCells > RMCharacterInfoCollectionViewCell`: vista de la segunda seccion del detalle, aquí se muestran las demás caracterícticas y detalles del personaje seleccionado.
-- `CharacterDetailsCells > RMCharacterEpisodeCollectionViewCell`: vista de la tercera seccion del detalle, muestra todos los episodios donde aparece el personaje, a la vez que busca si hay nuevos episodios para mostrar.
- Para el listado de los personajes `Views -> Episode`:
-- `RMEpisodeListView`: es la lista donde se muestran los episodios. Aquí se agregó un 'spinner' para indicar que se está cargando para mostrar los personajes iniciales y un 'collection' donde se registra la 'cell' y el 'spinner'.
-- Se agrego el protocolo 'Delegate' del ViewModel para mostrar los episodios y notificar que se ha seleccionado un episodio al 'Delegate' de esta vista.
-- Se creó el protocolo 'Delegate' de esta vista para notificar a su controller de listado que se ha seleccionado un episodio para mostrar su detalle.
- Para el detalle de los personajes `Views -> EpisodeDetails`:
-- `RMEpisodeDetailView`: es la vista donde se mostrará la información a detalle del episodio seleccionado. Tiene un 'spinner' que se muestra hasta que se obtenga toda la información del episodio; cuando se obtuvo todos los datos se oculta el 'spinner' y muestra el 'CollectionView' con todos los datos. Este 'CollectionView' contiene dos secciones de información: la primera es los detalles del episodio y la segunda son los personajes que aparecen por episodio: para hacer el diseño por secciones se hizo un diseño por composición 'UICollectionViewCompositionalLayout'.
-- Se creó el protocolo 'Delegate' de esta vista para notificar a su controller del detalle que se ha seleccionado un personaje para mostrar su detalle.
-- `RMEpisodeInfoCollectionViewCell`: contiene los elementos de la vista que muestra la información del episodio, para mostrar los personajes se reutilizó el `RMCharacterCollectionViewCell`.

En `ViewModels`:
- Para el listados de los personajes se creo:
-- `RMCharacterListViewViewModel`: este es el ViewModel de la lista-collection. Se creo el protocolo delegate que usa el 'RMCharacterListView'. Aquí se hace la llamada a la API y enviamos los datos necesario recibidos al 'RMCharacterCollectionViewCellViewModel' para quedarnos con el modelo de la vista.
-- Usamos el Protocolo 'UICollectionViewDataSource' para almacenar los datos en el Collection.
-- Usamos el Protocolo 'UICollectionViewDelegate' para notificar que se actualizará y mostrará el listado-collection en la vista con los datos. También se utilizó para recibir la acción de seleccionar una celda para ver los detalles del personaje.
-- Usamos el Protocolo 'UICollectionViewDelegateFlowLayout' para especificar los tamaños de las 'Cell' y del Footer del Collection.
-- Usamos el Protocolo 'UIScrollViewDelegate' para saber si estamos en la parte final del Collection y buscar más personajes si existieran.
-- Si existe mas personajes para mostrar, se hace nuevamente una llamada a la API para obtener los nuevos datos y realizamos la lógica para informar al 'Collection' que agregue más celdas de acuerdo a la cantidad de información obtenida y vuelve a llamar al protocolo 'UICollectionViewDataSource'.
-- `RMCharacterCollectionViewCellViewModel`: utilizamos el 'Hashable' para asignar un valor Hash único al ViewModel para evitar repeticiones y el 'Equatable' para comparar si existen datos iguales. Se creó para enviar sólo los datos necesarios para el listado de personajes en vez de enviar todos los datos del modelo.
- Para el detalle del personaje seleccionado:
-- `RMCharacterDetailViewViewModel`: recibe y envía los datos del personaje seleccionado a las diferentes secciones según corresponda. También crea el diseño de las secciones.
-- `CharacterDetailsCell > RMCharacterPhotoCollectionViewCellViewModel`: recibe la URL de la imagen y hace el llamado para obtenerla.
-- `CharacterDetailsCell > RMCharacterInfoCollectionViewCellViewModel`: recibe el tipo de información y su valor para hacer la lógica con ellos y devolver los datos correspondientes.
-- `CharacterDetailsCell > RMCharacterEpisodeCollectionViewCellViewModel`: recibe la url del episodio para obtener su información y devuelve el modelo. Se creó un protocolo con sus propiedades para enviar a la vista, en vez de mandar todo el modelo con datos que no se utilizará.
- Para el listado de los episodios:
-- `RMEpisodeListViewViewModel`: este es el ViewModel de la lista-collection, busca todos los episodios: iniciales y paginados.
-- Se creó un protocolo 'Delegate'  de este ViewModel para configurar la vista luego de buscar los episodios iniciales y paginados, a la vez que notifica a la vista que se seleccionó un episodio para visualizar su detalle.
-- Usamos el Protocolo 'UICollectionViewDataSource' para almacenar los datos en el Collection.
-- Usamos el Protocolo 'UICollectionViewDelegate' para notificar que se actualizará y mostrará el listado-collection en la vista con los datos. También se utilizó para recibir la acción de seleccionar una celda para ver los detalles del episodio.
-- Usamos el Protocolo 'UICollectionViewDelegateFlowLayout' para especificar los tamaños de las 'Cell' y del Footer del Collection.
-- Usamos el Protocolo 'UIScrollViewDelegate' para saber si estamos en la parte final del Collection y buscar más episodios si existieran.
- Para el detalle del episodio seleccionado:
-- `EpisodeDetail > RMEpisodeDetailViewViewModel`: recibe la URL del episodio seleccionado para buscar su información con sus personajes. Para hacer esta búsqueda utilizamos 'DispatchGroup' que notificará cuando se haya terminado de hacer todas las solicitudes-búsquedas.
-- Organiza los datos obtenidos de acuerdo a su tipo (información del episodio y personajes) para que en el detalle del episodio configure la vista.
-- Se creo el protocolo 'Delegate' de este ViewModel para notificar al detalle del episodio que ya se encontro todos los datos del detalle del episodio con sus personajes para que muestre el 'CollectionView' y oculte el 'spinner'.
-- `EpisodeDetail > RMEpisodeInfoCollectionViewCellViewModel`: continene las propiedas para el detalle del episodio por celda.

En `ApiClient`:
- RMService: responsable de hacer las llamadas a la API.
- RMRequest: construye la URL para que lo use el 'RMService' cuando lo llame.
- RMEndpoint: parte final de la URL cuando se muestra solo los listados.

En `Managers`:
- RMImageLoader: es el administrador de imágenes.
-- Cargar las imágenes usando el almacenamiento en cache de imágenes en memoria para evitar cargarlas desde la URL cuando ya se ha hecho anteriormente.
- RMAPICacheManager: crea objetos en cache de todos los tipos de vista si no existiran y almacena alli sus datos cuando se han buscado previamente para cuando se vuelva a requerir dicha información no vuelva a realizar peticiones a la URL sino que obtenga la información del cache.

> Nota: se esta usando Singleton para acceder a las siguientes clases: RMService, RMImageLoader.
Para obtener los cambios en el ViewModel del Episodio, se utiliza el patrón Published y Subscriber.
