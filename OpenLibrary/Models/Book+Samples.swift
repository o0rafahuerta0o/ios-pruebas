import Foundation

extension Book {
    static let samples: [Book] = [
        Book(id: "OL1", title: "Cien años de soledad", author: "Gabriel García Márquez",
             year: 1967, pages: 417, language: "Español",
             synopsis: "La historia de la familia Buendía a lo largo de siete generaciones en el pueblo de Macondo."),
        Book(id: "OL2", title: "El amor en los tiempos del cólera", author: "Gabriel García Márquez",
             year: 1985, pages: 368, language: "Español",
             synopsis: "Florentino Ariza espera más de cincuenta años para volver a estar con Fermina Daza."),
        Book(id: "OL3", title: "To Kill a Mockingbird", author: "Harper Lee",
             year: 1960, pages: 324, language: "Inglés",
             synopsis: "Scout Finch cuenta cómo su padre, un abogado, defiende a un hombre acusado injustamente."),
        Book(id: "OL4", title: "The Great Gatsby", author: "F. Scott Fitzgerald",
             year: 1925, pages: 180, language: "Inglés",
             synopsis: "Nick Carraway observa la vida de su vecino, el misterioso millonario Jay Gatsby."),
        Book(id: "OL5", title: "1984", author: "George Orwell",
             year: 1949, pages: 328, language: "Inglés",
             synopsis: nil)
    ]
}
