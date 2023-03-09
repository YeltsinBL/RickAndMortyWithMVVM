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
-- RMCharacterViewController: para visualizar los personajes.
-- RMEpisodeViewController: para visualizar los episodios.
-- RMLocationViewController: para visualizar las ubicaciones.
-- RMSettingsViewController: para realizar configuraciones dentro de la aplicación.

En `Models`:
- Se creó dos carpetas para diferencia los modelos:
-- APIResponseTypes: para mapear el Json que se recibe de acuerdo al tipo de objeto.
-- DataTypes: son los tipos de datos separados.

En `Views`:
- Para los personajes se creo:
-- `RMCharacterListView`: es la lista donde se muestra los personajes, aquí se agregó un 'spinner' para indicar que se está cargando para mostrar los personajes iniciales y un 'collection' donde se registra la 'cell' y el 'spinner'; y se agrego el protocolo 'Delegate' del ViewModel.
-- RMCharacterCollectionViewCell: aquí se crean y configuran los elementos que contendrá cada cell y se los relaciona con los datos que llega del ViewModel.
-- `RMFooterLoadingCollectionReusableView`: esta es una vista reusable. Se creo y configuro el 'spinner' que se mostrará al final del 'Collection'.

En `ViewModels`:
- Para los personajes se creo:
-- `RMCharacterListViewViewModel`: este es el ViewModel de la lista-collection. Se creo el protocolo delegate que usa el 'RMCharacterListView'. Aquí se hace la llamada a la API y enviamos los datos necesario recibidos al 'RMCharacterCollectionViewCellViewModel' para quedarnos con el modelo de la vista.
-- Usamos el Protocolo 'UICollectionViewDataSource' para almacenar los datos en el Collection.
-- Usamos el Protocolo 'UICollectionViewDelegate' para notificar que se actualizará y mostrará el listado-collection en la vista con los datos.
-- Usamos el Protocolo 'UICollectionViewDelegateFlowLayout' para especificar los tamaños de las 'Cell' y del Footer del Collection.
-- Usamos el Protocolo 'UIScrollViewDelegate' para saber si estamos en la parte final del Collection y buscar más personajes si existieran.
-- Si existe mas personajes para mostrar, se hace nuevamente una llamada a la API para obtener los nuevos datos y realizamos la lógica para informar al 'Collection' que agregue más celdas de acuerdo a la cantidad de información obtenida y vuelve a llamar al protocolo 'UICollectionViewDataSource'.
-- `RMCharacterCollectionViewCellViewModel`: utilizamos el 'Hashable' para asignar un valor Hash único al ViewModel para evitar repeticiones y el 'Equatable' para comparar si existen datos iguales.

En `ApiClient`:
- RMService: responsable de hacer las llamadas a la API.
- RMRequest: construye la URL para que lo use el 'RMService' cuando lo llame.
- RMEndpoint: parte final de la URL cuando se muestra solo los listados.

En `Managers`:
- RMImageLoader: es el administrador de imágenes.
-- Cargar las imágenes usando el almacenamiento en cache de imágenes en memoria para evitar cargarlas desde la URL cuando ya se ha hecho anteriormente.

> Nota: se esta usando Singleton para acceder a las siguientes clases: RMService, RMImageLoader.
