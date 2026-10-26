import Foundation

protocol BookService {
    func search(_ text: String) async throws -> [Book]
}
