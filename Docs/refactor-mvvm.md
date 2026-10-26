# Refactorización hacia MVVM

## 1. Punto de partida

Teníamos 11 archivos `.swift` todos juntos en la misma carpeta. Al ir leyendo archivo por archivo encontramos varias cosas que nos parecieron mejorables:

| # | Problema | Dónde estaba | Por qué lo consideramos un problema |
|---|---|---|---|
| 1 | La lógica de búsqueda (filtrar, simular la espera, manejar los estados) estaba dentro de la vista | `SearchView` | Al conectar la API la vista iba a tener también la red y los errores, y ya estaba mezclando dibujar con decidir |
| 2 | La validación del login estaba en la vista | `LoginView` | Es una regla de la app, y no algo del diseño |
| 3 | El formato de los datos que faltan ("—", pasar el año a texto) estaba en la vista | `BookDetailView` | Es lógica de presentación y no debería depender de cómo se dibuja la pantalla |
| 4 | Código repetido: `NavigationLink` + `BookCard` + `buttonStyle(.plain)`, y también `toolbar(.hidden)` + `navigationDestination` | `SearchView` y `MyBooksView` | Si cambiaba algo del detalle había que acordarse de editarlo en dos lugares |
| 5 | El texto `"savedUsername"` escrito a mano en tres archivos | `RootView`, `LoginView`, `HomeView` | Con un error de dedo el login dejaría de funcionar y Xcode no avisaría |
| 6 | `Book` tenía la regla de búsqueda (`matches`) y los datos de prueba | `Book.swift` | El modelo debería tener solo datos |
| 7 | `Components.swift` tenía dos vistas distintas | `Components.swift` | Costaba trabajo encontrar cada una |
| 8 | No existía el estado de error en la búsqueda, aunque sí estaba en el diseño de la práctica 3 | `SearchView` | Nos faltaba cumplir con lo que habíamos diseñado |
| 9 | Todos los archivos estaban en una sola carpeta | proyecto | Ya no se distinguía qué era vista, qué era dato y qué era lógica |

## 2. Cambios realizados

- Movimos los archivos a `App`, `Models`, `Services`, `Stores`, `ViewModels` y `Views` (con subcarpetas por pantalla). `Components.swift` lo separamos en `BookCard.swift` y `CoverPlaceholder.swift`.
- Creamos `StorageKey.username` y cambiamos los tres `@AppStorage("savedUsername")` por `@AppStorage(StorageKey.username)`.
- Hicimos `BookList` (el `ScrollView` con las tarjetas que llevan al detalle) y `bookNavigation()` (ocultar la barra y declarar el `navigationDestination`). Ahora `SearchView` y `MyBooksView` usan los dos.
- Creamos el protocolo `BookService` y `MockBookService`. Ahí quedó el filtrado y la espera simulada. Los datos de prueba pasaron a `Book+Samples.swift` y `Book` se quedó solo con sus propiedades.
- `SearchViewModel` Guarda `query`, `results`, `searchedText` y `state` (`idle`, `loading`, `loaded` y `failed`), y tiene el método `search()`. La vista solo lee esos valores y llama a `search()` cuando se presiona buscar. Aprovechamos para agregar el estado de error que faltaba. Como `MockBookService` nunca falla, ese estado todavía no lo hemos visto en pantalla, pero ya queda listo para cuando conectemos la API.
- `LoginViewModel` Guarda `username` y `errorMessage`, y tiene `validate()`, que regresa el nombre ya limpio o `nil` si el campo está vacío. Guardar el usuario en `@AppStorage` lo dejamos en la vista.
- `BookDetailViewModel`Tiene los textos con valor por defecto (`pagesText`, `languageText`, `yearText` y `synopsisText`) y los métodos `isSaved(in:)` y `toggleSaved(in:)`.

## 3. Decisiones que tomamos

- **`@State` para el ViewModel.** En `SearchView` el ViewModel está en un `@State` en la raíz del `NavigationStack`, así que sigue guardando la búsqueda cuando se regresa del detalle.
- **El store entra como parámetro.** En `BookDetailViewModel` los métodos reciben el `LibraryStore` porque el `environment` solo se puede leer dentro de la vista y no en el `init` del ViewModel.
- **`BookService` como protocolo.** Así el ViewModel no necesita saber de dónde vienen los datos, y más adelante podemos cambiar `MockBookService` por la API sin tocarlo.
- **`LoginViewModel` y `BookService`.** En la práctica 4 los habíamos dejado para más adelante, pero ahora sí los hicimos. El login ya tenía una regla de validación mezclada con el diseño, y con el servicio podemos cambiar los datos de prueba por la API sin modificar el ViewModel de búsqueda.

## 4. Lo que no cambiamos

- **`HomeView` y `MyBooksView`:** no les hicimos ViewModel porque solo muestran datos. Hacerles uno sería agregar una capa que no hace nada.
- **`LibraryStore`:** ya funcionaba bien como almacén compartido, así que lo dejamos igual y solo lo cambiamos de carpeta.
- **La navegación (`RootView`, `MainTabView`, `NavigationStack`):** sigue como la definimos en la práctica 3.
- **El diseño:** sigue siendo el mismo.

## 5. Estructura actual de los archivos

```
OpenLibrary/
├── App/
│   ├── OpenLibraryApp.swift
│   ├── RootView.swift
│   ├── MainTabView.swift
│   └── StorageKey.swift
├── Models/
│   ├── Book.swift
│   └── Book+Samples.swift
├── Services/
│   ├── BookService.swift
│   └── MockBookService.swift
├── Stores/
│   └── LibraryStore.swift
├── ViewModels/
│   ├── LoginViewModel.swift
│   ├── SearchViewModel.swift
│   └── BookDetailViewModel.swift
└── Views/
    ├── Login/LoginView.swift
    ├── Home/HomeView.swift
    ├── Search/SearchView.swift
    ├── MyBooks/MyBooksView.swift
    ├── Detail/BookDetailView.swift
    └── Components/
        ├── BookCard.swift
        ├── BookList.swift
        ├── BookNavigation.swift
        └── CoverPlaceholder.swift
```

## 6. Cómo saber que el comportamiento es el mismo

Este es el recorrido que usamos para verificar que la app se comporta igual que en la práctica anterior:

1. Con el campo de usuario vacío aparece "Escribe un nombre de usuario".
2. Al ingresar con un nombre se ve el Home con "Hola, [nombre]".
3. En Buscar, escribir "garcía" y buscar muestra "Cargando resultados" y luego dos libros.
4. Buscar algo que no existe muestra "Sin resultados para …".
5. Al abrir un libro y regresar con la flecha, la búsqueda y los resultados siguen ahí.
6. En el detalle, "1984" muestra "Sin sinopsis disponible".
7. Al guardar un libro, el botón cambia a "Eliminar de mis libros" y el libro aparece en Mis libros.
8. Al eliminarlo, desaparece de Mis libros.
9. Al cerrar sesión se regresa al login, y si se cierra y abre la app con la sesión iniciada no se vuelve a pedir el usuario.