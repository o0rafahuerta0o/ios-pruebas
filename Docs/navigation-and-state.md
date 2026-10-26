<img width="613" height="630" alt="Captura de pantalla 2026-10-04 221636" src="https://github.com/user-attachments/assets/fc88d5e1-9496-4fb5-8c27-3b5710207991" />

## Información por pantalla

### Inicio de sesión

| Aspecto | Detalle |
|---|---|
| *Muestra* | Encabezado "Open Library", campo "Usuario" (placeholder "Insertar nombre de usuario"), botón "Ingresar", mensaje de error si el campo está vacío ("Escribe un nombre de usuario"). |
| *Recibe* | Nada al inicio. Solo necesita acceso a la sesión global para poder guardar el usuario. |
| *Modifica* | El texto que se escribe (temporal) y, al presionar "Ingresar", el usuario de la sesión (dato global). |
| *Conserva* | Temporal: el texto escrito y el mensaje de error (solo mientras la pantalla existe). Persistente: el nombre de usuario, para no pedirlo en cada apertura. |

### Home

| Aspecto | Detalle |
|---|---|
| *Muestra* | El título "Open Library" y el mensaje de bienvenida: "Bienvenido a OpenLibrary, en donde podrás buscar y encontrar cualquier libro que quieras". |
| *Recibe* | El nombre del usuario que inició sesión, guardado al ingresar en la pantalla de login. |
| *Modifica* | Solo la ruta de navegación, cuando el usuario presiona una pestaña de la barra inferior. No modifica datos. |
| *Conserva* | De forma temporal, el nombre del usuario activo. No guarda listas ni requiere persistencia. |

### Busca algún libro + resultados

| Aspecto | Detalle |
|---|---|
| *Muestra* | Encabezado "Busca algún libro", barra de búsqueda ("Buscar por título o autor"), mensaje "Resultados encontrados"; tarjetas (título, autor, año), estados: sin consulta, "Cargando resultados", "Sin resultados para …", error. |
| *Recibe* | Resultados de la API para el texto buscado. |
| *Modifica* | El texto de búsqueda, la lista de resultados y la ruta de navegación de la pestaña. |
| *Conserva* | Texto buscado y resultados mientras la app esté abierta, de modo que al volver del detalle (flecha atrás) el usuario vea lo mismo que dejó. No necesita persistir entre sesiones. |

### Mis libros

| Aspecto | Detalle |
|---|---|
| *Muestra* | Encabezado "Mis libros", lista de libros guardados (portada, título, autor), estado vacío "Aún no has guardado libros". |
| *Recibe* | La colección de libros guardados. |
| *Modifica* | Solo la ruta de navegación. |
| *Conserva* | Nada propio: es una vista del almacén. Si un libro se guarda desde otra pestaña, esta lista se actualiza sola. |

### Detalle del libro

| Aspecto | Detalle |
|---|---|
| *Muestra* | Flecha de regreso, título de encabezado ("Detalles"), portada, título, autor, número de páginas, idioma, año de publicación, sección "Sinopsis" con su texto, y el botón dinámico ("Guardar en mis libros" o "Eliminar de mis libros" según corresponda). |
| *Recibe* | Un objeto Libro (el libro seleccionado por el usuario) como parámetro de entrada, y acceso a la lista global de "Mis libros" para verificar si el libro ya se encuentra guardado. |
| *Modifica* | Agrega o elimina el libro de la lista global de "Mis libros" al presionar el botón. Opcionalmente, completa los campos faltantes (como la sinopsis) tras consultar los datos detallados de la obra. |
| *Conserva* | De forma temporal: el estado de carga de la sinopsis y los posibles errores de red. El estado de "estar guardado" no lo conserva esta vista de forma local: lo consulta directamente al almacén central de la app. |



# Organización del estado
### A partir del MVP los datos se organizan de esta manera:
### Usuario de la sesion:
- donde vive: en la parte de AppStorage / UserDefaults, es accesible de manera global por ejemplo cuando es inyectado como variable de entorno o leido directamente con @AppStorage en cada pantalla que lo necesite.

- por que:porque debe de sobrevivir a la hora de que la app se cierra, porque anteriormente se menciona (en los puntos anteriores), pide que no se vuelva pedir en cada apertura es por eso que no basta con el @State, se tiene que guardar en disco, ademas, varias pantallas lo necesitan leer como el home para el saludo, inicio de sesion para saber si ya existe, entonces si o si tiene que ser accesible de manera global y como tal no hace falta la base de datos porque solo ser un valor simple, AppStorage alcanza.

### Texto de busqueda y resultados de "Busca algun libro":
- donde vive: en 'SearchView', la pantalla raiz de la pestaña buscar, como @State. SearchView es la unica dueña (owner), del estado; 'SearchResultsView' y las tarjetas solo reciben los datos para mostrarlos, y el detalle no recibe ni modifica el estado de busqueda.

- por que: porque solo esa pestaña usa la busqyeda y solo necsita conservarse mientras la app esta abierta. La raiz del NavigationStack no se destruye al abrir el detalle (solo queda atras), asi que al volver con la felcha atras la busqueda sigue ahi. si el dueño fuera el detalle, se perderia al regresar, y con un solo dueño no hya copias que se desincronicen.

### Coleccion "Mis libros":
- donde vive: en un almacen compartido y observable como podria ser una clase @Observable o ObservableObject que podria ser llamda algo como LibraryStore, haciendo una inyeccion una sola vez en la raiz de la app con .environment y leido desde ahi por cualquier pantalla que lo necesite.

- por que: porque dos pantallas que son independientes necesitan tocar el mismo dato: "Detalle del libro" lo modifica ya sea que agregue o quite un libro, tambien cuando  lo llegue a lee, para saber si mostrar "Guardar" o "Eliminar"; "Mis libros" solo puede leerlo, pero debe enterarse al instante cuando cambia.

###  Objeto Book mostrado en el Detalle:
- donde vive: en la propia pantalla de detalle, recibido como parámetro al navegar let book: Book, y no se guarda en ninguna otra parte.

- que trae y que se consulta: el Book que se envía trae solo lo que ya se conoce de los resultados: id, título, autor, año y portada. Con el id, el Detalle consulta lo que falta: la sinopsis (siempre) y las páginas e idioma si no venían en el resultado. Si el libro está guardado o no, no se consulta a la API: se pregunta a LibraryStore con el id.

- por que: así el Detalle muestra de inmediato lo que ya sabe y solo carga lo que falta, sin pedir otra vez datos que ya tiene ni descargar la sinopsis de todos los resultados cuando el usuario solo abrirá uno.

### Estado de carga de la sinopsis y errores de red:
- donde vive: en la pantalla local de detalle, como @State.

- por que: porque solo le iteresa a esa pantalla en ese momento. Cuando el usuario sale del detalle, ese estado deja de tener sentido y al volver a entrar la carga empieza de cero.

### Mensaje de error de "inicio de sesion" (en el campo vacio):
- donde vive: en la pantalla local de inicio de sesion, como @State.

- por que: porque solo existe mientras el usuario esta en esa pantalla intentando ingresar. En cuanto inicia sesion y pasa a la barra de pestañas, el mesnaje ya no tiene sentido.


# Estrategia de navegacion
Como tal los flujos de navegacion continenen tres niveles.

- Nivel 1: sesion iniciada o no.

esto decide si el usuario ve el inicio de sesion o la brra de pestañas completa. los mecanismo que podria utilizar una vista raiz por ejemplo RootView que decide  con un simple if / else que mostrar, segun si existe un usuario guardado. como savedUsername vive AppStorage, este if se reevalua solo en cuanto el usuario presiona "ingresar" y el valor cambia.

 - Nivel 2: La barra de pestañas
 en este caso las tres secciones principales como Home, buscar, Mis libros, se implementan con un TabView, que es el componente nativo  de SwiftUI para barras de pestañas en la parte inferior. Cada pantalla es independiente entre si.

 Nivel 3: Navegacion dentro de cada pestaña (ir al detalle y volver)

- Tanto "buscar" como "Mis Libros" necesitan poder entrar al  detalle de un libro y volver atras. entonces para esto, cada  una de esas dos pestañas  debe de envolver su propio contenido en un NavigationStack independiente, en vez de compartir uno solo entre toda la app. Es importante porque si el usuario entra a un detalle desde "Buscar" y luego cambia a la pestaña "Mis libros", se espera que esta ultima aparezca en su propia pantalla principal.

Dentro de cada NavigationStack, la tarjeta de libro se convierte en un NavigationLink(value: book), y cada pestaña declara a donde debe llevar ese valor con  .navigationDestination(for: Book.self) { book in BookDetailView(book: book) }. esto es preferible a crear el NavigationLink apuntando directo a la vista, porque, al pasar el valor(el objeto Book) en vez de la vista ya armada, es mas facil reusar la misma logica de navegacion desde  las dos pestañas distintas(Buscar y mis libros).

para la flecha de regreso personalizada que se ven en los wirefrimes, se puede usar @Environment(\.dismiss) dentro de BookDetailView: se oculta el boton  de regreso por defecto (.navigationBarBackButtonHidden(true)) y se agrega un boton propio en la barra, con el icono de flecha, que llama a dismiss() al tocarlo.


por ultimo, esta estructura resuelve de forma natural el requisito de que, al volver la flecha atras, "Busca algun libro" conserve la busqueda y los resultados que el usuario habia dejado: como ese estado vive en @State en la pantalla raiz del NavigationStack de esa pestaña y  NavigationStack no destruye esa pantalla al navegar hacia adelante (solo la oculta detras del detalle), el estado sigue intacto en memoria y reaparece tal cual al regresar, sin necesidad de guardarlo ni recuperarlo manualmente.
