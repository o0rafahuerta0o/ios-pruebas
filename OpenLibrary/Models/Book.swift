import Foundation

struct Book: Identifiable, Hashable {
    let id: String
    let title: String
    let author: String
    let year: Int?
    var pages: Int?
    var language: String?
    var synopsis: String?
}
