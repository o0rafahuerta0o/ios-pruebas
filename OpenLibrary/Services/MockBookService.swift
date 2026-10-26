import Foundation

struct MockBookService: BookService {
    func search(_ text: String) async throws -> [Book] {
        try await Task.sleep(for: .seconds(0.5))  
        let options: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]
        return Book.samples.filter {
            $0.title.range(of: text, options: options) != nil
            || $0.author.range(of: text, options: options) != nil
        }
    }
}
