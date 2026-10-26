import Foundation
import Observation

@Observable
final class SearchViewModel {
    enum State {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    var query = ""
    private(set) var results: [Book] = []
    private(set) var state: State = .idle
    private(set) var searchedText = ""

    private let service: BookService

    init(service: BookService = MockBookService()) {
        self.service = service
    }

    func search() async {
        let text = query.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }

        searchedText = text
        state = .loading
        do {
            results = try await service.search(text)
            state = .loaded
        } catch {
            state = .failed("No se pudo completar la búsqueda")
        }
    }
}
