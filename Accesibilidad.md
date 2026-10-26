# Accesibilidad OpenLibrary

![Wireframe: inicio de sesión](img/wireframe-inicio-sesion.png)

## Pantalla 1: Inicio de sesión

| Elemento                   | Tipo           | ¿Se anuncia? | Descripción                                                                      |
|----------------------------|----------------|--------------|----------------------------------------------------------------------------------|
| Open Library               | Encabezado     | Sí           | Se lee: "Open Library, encabezado".                                              |
| Etiqueta "Usuario" + campo | Campo de texto | Sí           | Un solo elemento. Se lee: "Usuario, campo de texto. Insertar nombre de usuario". |
| Botón Ingresar             | Botón          | Sí           | Se lee: "Ingresar, botón". Si está deshabilitado: "No disponible".               |
| Error de campo vacío       | Mensaje        | Sí           | Se anuncia al aparecer, sin mover el enfoque: "Escribe un nombre de usuario".    |

![Wireframes: búsqueda y detalle del libro](img/wireframe-busqueda-detalle.png)

## Pantalla 2: Busca algún libro

| Elemento               | Tipo              | ¿Se anuncia? | Descripción                                             |
|------------------------|-------------------|--------------|---------------------------------------------------------|
| Busca algún libro      | Encabezado        | Sí           | Se lee: "Busca algún libro, encabezado".                |
| Barra de búsqueda      | Campo de búsqueda | Sí           | Se lee: "Buscar por título o autor, campo de búsqueda". |
| Lupa de la barra       | Ícono             | No           | Decorativa; la barra ya tiene etiqueta.                 |
| Pestaña Home           | Pestaña           | Sí           | Se lee: "Home, pestaña, seleccionada".                  |
| Pestaña Buscar         | Pestaña           | Sí           | Se lee: "Buscar, pestaña".                              |
| Pestaña Mis libros     | Pestaña           | Sí           | Se lee: "Mis libros, pestaña".                          |
| Íconos de las pestañas | Ícono             | No           | Se lee solo el texto de la pestaña.                     |

## Pantalla 3: Detalle del libro (guardar)

| Elemento                    | Tipo       | ¿Se anuncia? | Descripción                                                                                                                  |
|-----------------------------|------------|--------------|------------------------------------------------------------------------------------------------------------------------------|
| Flecha de regreso           | Botón      | Sí           | Se lee: "Regresar, botón".                                                                                                   |
| Detalles                    | Encabezado | Sí           | Se lee: "Detalles, encabezado".                                                                                              |
| Portada                     | Imagen     | Sí           | Se lee: "Portada de To Kill a Mockingbird".                                                                                  |
| Título del libro            | Encabezado | Sí           | Se lee: "To Kill a Mockingbird, encabezado".                                                                                 |
| Autor                       | Texto      | Sí           | Se lee: "Harper Lee".                                                                                                        |
| Páginas                     | Texto      | Sí           | Una sola frase: "Páginas: 324".                                                                                              |
| Idioma                      | Texto      | Sí           | Una sola frase: "Idioma: Inglés".                                                                                            |
| Año de publicación          | Texto      | Sí           | Una sola frase: "Año de publicación: 1960".                                                                                  |
| Sinopsis                    | Encabezado | Sí           | Se lee: "Sinopsis, encabezado".                                                                                              |
| Texto de la sinopsis        | Texto      | Sí           | Se lee el párrafo completo. Si es largo, ofrecer "Ver más".                                                                  |
| Botón Guardar en mis libros | Botón      | Sí           | Se lee: "Guardar en mis libros, botón".                                                                                      |
| Ícono de marcador del botón | Ícono      | No           | El texto ya dice la acción.                                                                                                  |
| Cambio de estado al guardar | Mensaje    | Sí           | Se anuncia: "Libro guardado en Mis libros". El enfoque se queda en el botón, que ahora dice "Eliminar de mis libros, botón". |

![Wireframes: búsqueda, resultados y detalle](img/wireframe-resultados.png)

## Pantalla 4: Resultados de búsqueda

| Elemento                           | Tipo              | ¿Se anuncia? | Descripción                                                                                                       |
|------------------------------------|-------------------|--------------|-------------------------------------------------------------------------------------------------------------------|
| Flecha de regreso                  | Botón             | Sí           | Se lee: "Regresar, botón".                                                                                        |
| Campo con texto buscado            | Campo de búsqueda | Sí           | Se lee: "Buscar por título o autor, campo de búsqueda, Gabriel García Márquez".                                   |
| Resultados encontrados             | Encabezado        | Sí           | Se lee: "Resultados encontrados, encabezado".                                                                     |
| Estado de carga                    | Mensaje           | Sí           | Se anuncia automáticamente: "Cargando resultados".                                                                |
| Tarjeta del libro                  | Botón             | Sí           | Un solo elemento con título, autor y año. Se lee: "Cien años de soledad, de Gabriel García Márquez, 1967, botón". |
| Portada/ícono dentro de la tarjeta | Imagen            | No           | No es necesario describir la imagen porque el título ya identifica el libro.                                      |
| Sin resultados                     | Mensaje           | Sí           | Se anuncia: "Sin resultados para Gabriel García Márquez".                                                         |

![Wireframes: Mis libros y detalle](img/wireframe-mis-libros.png)

## Pantalla 5: Mis libros

| Elemento                      | Tipo       | ¿Se anuncia? | Descripción                                                              |
|-------------------------------|------------|--------------|--------------------------------------------------------------------------|
| Mis libros                    | Encabezado | Sí           | Se lee: "Mis libros, encabezado".                                        |
| Lista de libros guardados     | Lista      | Sí           | Se lee: "Lista, 3 elementos".                                            |
| Tarjeta de libro              | Botón      | Sí           | Un solo elemento. Se lee: "To Kill a Mockingbird, de Harper Lee, botón". |
| Íconos de portada en tarjetas | Ícono      | No           | Decorativos.                                                             |
| Pestaña Mis libros            | Pestaña    | Sí           | Se lee: "Mis libros, pestaña, seleccionada".                             |
| Estado vacío                  | Mensaje    | Sí           | Se lee: "Aún no has guardado libros".                                    |

## Pantalla 6: Detalle desde Mis libros (eliminar)

| Elemento               | Tipo               | ¿Se anuncia? | Descripción                                                                                |
|------------------------|--------------------|--------------|--------------------------------------------------------------------------------------------|
| Flecha de regreso      | Botón              | Sí           | Se lee: "Regresar, botón".                                                                 |
| Detalles               | Encabezado         | Sí           | Se lee: "Detalles, encabezado".                                                            |
| Portada                | Imagen             | Sí           | Se lee: "Portada de To Kill a Mockingbird".                                                |
| Título del libro       | Encabezado         | Sí           | Se lee: "To Kill a Mockingbird, encabezado".                                               |
| Autor                  | Texto              | Sí           | Se lee: "Harper Lee".                                                                      |
| Páginas / Idioma / Año | Texto              | Sí           | Cada dato en una sola frase: "Páginas: 324", "Idioma: Inglés", "Año de publicación: 1960". |
| Sinopsis               | Encabezado y texto | Sí           | Se lee: "Sinopsis, encabezado" y luego el párrafo.                                         |
| Eliminar de mis libros | Botón              | Sí           | Se lee: "Eliminar de mis libros, botón".                                                   |
| Resultado de eliminar  | Mensaje            | Sí           | Se anuncia: "Libro eliminado de Mis libros".                                               |
