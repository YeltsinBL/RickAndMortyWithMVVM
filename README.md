# RickAndMortyWithMVVM
Aplicación usando la api de Rick and Morty con la arquitectura MVVM.

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