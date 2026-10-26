# Navegación, estado compartido y propuesta MVVM

## 1. ¿Qué se implementó?

**Navegación (los tres niveles de la práctica 3)**

- **Nivel 1:** `RootView` revisa con un `if / else` si existe `savedUsername` (guardado con `@AppStorage`). Si está vacío muestra `LoginView`, y si no, el `MainTabView`. Cuando el usuario presiona "Ingresar" el valor cambia y la vista se reevalúa sola.
- **Nivel 2:** `MainTabView` es un `TabView` con Home, Buscar y Mis libros.
- **Nivel 3:** Buscar y Mis libros tienen cada una su propio `NavigationStack`. Las tarjetas son `NavigationLink(value: book)` y cada pestaña declara `.navigationDestination(for: Book.self)` que lleva a `BookDetailView`. La flecha de regreso es propia: se oculta la default con `.navigationBarBackButtonHidden(true)` y el botón llama a `dismiss()`.

**Información compartida entre vistas**

Se eligió el caso de "Mis libros". Se hizo la clase `LibraryStore` con `@Observable`, se crea una sola vez en `OpenLibraryApp` y se inyecta con `.environment(library)`. Dos pantallas distintas usan el mismo dato:

- `BookDetailView` lo lee (`contains`) para decidir si muestra "Guardarlo" o "Eliminar", y lo modifica (`add` / `remove`).
- `MyBooksView` lo lee y se actualiza sola cuando cambia.

Se probó guardando un libro desde Buscar y cambiando a Mis libros, y aparece sin hacer nada más. También se conserva la búsqueda al volver del detalle porque el `@State` está en la raíz del `NavigationStack`.

**Cosas que cambiaron respecto a la práctica 3**

- Se quitaron los archivos de los wireframes estáticos (`HundredYearsDetailView`, `MockingbirdDetailView`, `SavedBookDetailView`, `SearchResultsView`, `HomeSearchView`, `HomeWelcomeView`) porque ahora hay un solo `BookDetailView` que recibe un `Book`.
- Se quitaron `FixedTabs`, que se usaba para simular la barra de pestañas, y lo cambié por el `TabView` real.
- `CoverPlaceholder` estaba copiado en casi todos los archivos, así que lo moví a `Components.swift`.
- Los datos son de prueba (`Book.samples`) y la búsqueda filtra localmente con un retraso de medio segundo para simular la carga. Aún no se ha conectado a la API.
- Se agregó un botón "Cerrar sesión" en Home solo para poder probar el login varias veces.

## 2. Análisis de la estructura actual

Se revisó qué hace cada vista además de dibujar la pantalla:

| Vista | Responsabilidades que tiene ahora | ¿Debería salir de la vista? |
|---|---|---|
| `LoginView` | Valida que el nombre no esté vacío, quita espacios, decide el mensaje de error y guarda el usuario. | La validación sí. Mostrar el campo y el error se queda. |
| `SearchView` | Guarda texto y resultados, filtra `Book.samples`, simula la espera, maneja los estados (inicial, cargando, con resultados, sin resultados). | Sí, es la que más lógica tiene. |
| `BookDetailView` | Pregunta si el libro está guardado y decide si agrega o elimina. A futuro cargará la sinopsis. | En parte, sobre todo la carga de datos. |
| `MyBooksView` | Solo lee el store y muestra la lista. | No, ya es muy simple. |
| `HomeView` | Muestra el saludo con el usuario. | No. |

## 3. Por qué separar responsabilidades

Dentro de una app hay código de tres tipos. Está el de la interfaz, que es lo que se ve y cómo responde cuando el usuario toca algo, como los botones y las listas. Está el de los datos, que es de dónde sale la información (la API, `@AppStorage` o el modelo `Book`). Y está el de la lógica, que es lo que se decide cuando el usuario hace algo, por ejemplo validar un texto, hacer la búsqueda o decidir si un libro se guarda o se elimina.

El problema es que en SwiftUI es muy fácil meter todo en la misma vista, y eso es lo que ya empieza a pasar en el `SearchView`. Cuando una vista hace todo, se vuelve larga y cuesta trabajo encontrar qué parte hace qué, porque el código que dibuja la pantalla queda revuelto con el de la lógica. Además, más adelante al conectar la API, se tendrá que modificar la misma vista que dibuja la interfaz, y eso puede romper cosas que ya funcionaban. Otra desventaja es que la lógica queda "atrapada" en la pantalla, así que no se puede probar por separado ni reutilizar en otra vista.

Por eso MVVM propone repartir el trabajo en tres partes:

- **Model:** son los datos de la app. En este caso es `Book`.
- **View:** solo dibuja la pantalla y le avisa al ViewModel cuando el usuario hace algo.
- **ViewModel:** guarda el estado de la pantalla y se encarga de la lógica, para que la vista solo tenga que mostrar lo que él tiene.

Con el ejemplo de la búsqueda se entiende mejor cómo se conectan:

1. El usuario escribe un título y presiona buscar.
2. La vista llama a `viewModel.search()`.
3. El ViewModel cambia el estado a "cargando", pide los datos y al final guarda los resultados.
4. Como la vista está pendiente de ese estado, se actualiza sola y muestra los resultados.

O sea que la vista ya no decide nada, solo muestra lo que el ViewModel le dice.

## 4. Propuesta de MVVM

**Model:** `Book` (ya existe). Con la API probablemente se agregue un modelo aparte para decodificar la respuesta y lo convierta a `Book`.

**Qué datos viajan en `Book`:** al navegar al detalle se envía el `Book` completo con lo que trajo la búsqueda (id, título, autor, año y, si la API los incluye, páginas e idioma). La sinopsis es lo que normalmente habría que pedir aparte usando el `id`, y por eso `BookDetailViewModel` tendría un `loadDetails()`.

**ViewModel:** clases `@Observable` que guardan el estado de una pantalla y la lógica asociada.

| ViewModel | Qué guardaría | Qué métodos tendría |
|---|---|---|
| `LoginViewModel` | `username`, `errorMessage` | `login()` que valida y regresa si fue válido |
| `SearchViewModel` | `query`, `results`, `state` | `search()` |
| `BookDetailViewModel` | `book`, estado de carga de la sinopsis, error | `loadDetails()`, `toggleSaved()` |

`HomeView` y `MyBooksView` no necesitan ViewModel por ahora. Se quedarían leyendo directo de `@AppStorage` y de `LibraryStore`.

**Servicio:** `BookService` sería quien llame a la API (o devuelva los datos de prueba). El `SearchViewModel` lo usaría para buscar, así la vista no sabe de dónde vienen los datos. `LibraryStore` se queda como está, porque ya funciona como almacén compartido y se lo pasaría al `BookDetailViewModel`.

**View:** solo dibuja según el estado del ViewModel y le avisa de las acciones del usuario (por ejemplo, el botón llama a `viewModel.login()`).

Estructura de carpetas que pensé:

```
OpenLibrary/
├── App/            OpenLibraryApp, RootView, MainTabView
├── Models/         Book
├── Services/       BookService
├── Stores/         LibraryStore
├── ViewModels/     LoginViewModel, SearchViewModel, BookDetailViewModel
└── Views/
    ├── Login/      LoginView
    ├── Home/       HomeView
    ├── Search/     SearchView
    ├── MyBooks/    MyBooksView
    ├── Detail/     BookDetailView
    └── Components/ BookCard, CoverPlaceholder
```

Ejemplo de cómo quedaría `SearchViewModel`:

```swift
@Observable
final class SearchViewModel {
    var query = ""
    var results: [Book] = []
    var state: SearchState = .idle
    private(set) var searchedText = ""

    func search() async {
    }
}
```

Y en la vista:

```swift
struct SearchView: View {
    @State private var viewModel = SearchViewModel()
}
```

Es importante que el `@State` del ViewModel siga en `SearchView`, que es la raíz del `NavigationStack`. Así se conserva la búsqueda al volver del detalle igual que ahora.

**Qué se quedaría fuera de MVVM:** el usuario de la sesión se queda en `@AppStorage` porque es un solo valor y lo leen varias pantallas, y el estado de navegación (`NavigationStack`, `dismiss`) se queda en las vistas porque es algo propio de SwiftUI.
