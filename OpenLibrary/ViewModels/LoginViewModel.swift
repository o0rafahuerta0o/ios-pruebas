import Foundation
import Observation

@Observable
final class LoginViewModel {
    var username = ""
    private(set) var errorMessage: String?

    func validate() -> String? {
        let name = username.trimmingCharacters(in: .whitespaces)
        if name.isEmpty {
            errorMessage = "Escribe un nombre de usuario"
            return nil
        }
        errorMessage = nil
        return name
    }
}
