import SwiftUI

struct LoginView: View {
    @AppStorage(StorageKey.username) private var savedUsername = ""
    @State private var viewModel = LoginViewModel()

    var body: some View {
        VStack(spacing: 0) {
            Text("Open\nLibrary")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
                .padding(.top, 90)

            VStack(alignment: .leading, spacing: 12) {
                Text("Usuario")
                    .font(.title3)

                TextField("Insertar nombre de usuario", text: $viewModel.username)
                    .font(.subheadline)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

                Divider()

                if let message = viewModel.errorMessage {
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
            .padding(.top, 90)
            .padding(.horizontal, 24)

            Button {
                if let name = viewModel.validate() {
                    savedUsername = name   
                }
            } label: {
                Text("Ingresar")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 11)
                    .background(Color.blue, in: Capsule())
            }
            .padding(.top, 28)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
    }
}

#Preview { LoginView() }
