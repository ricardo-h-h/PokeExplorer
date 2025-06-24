import SwiftUI
import SwiftData

struct LoginView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    @AppStorage("loggedInUsername") private var loggedInUsername: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var username = ""
    @State private var password = ""
    
    @State private var showingRegisterView = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.large) {
                Spacer()
                
                Text("PokéExplorer")
                    .font(AppFont.pokemonTitle(size: 40))
                    .foregroundColor(AppColor.primary)
                
                // O VStack do formulário agora tem uma largura máxima
                VStack(spacing: AppSpacing.medium) {
                    TextField("Nome de usuário", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    SecureField("Senha", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .frame(maxWidth: 480) // <-- MUDANÇA APLICADA AQUI
                
                Button(action: loginUser) {
                    Text("Login")
                        .font(AppFont.pokemonBody().bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColor.primary)
                        .cornerRadius(12)
                }
                .frame(maxWidth: 480) // E no botão também para consistência
                
                Spacer()
                
                Button(action: {
                    showingRegisterView = true
                }) {
                    Text("Não tem uma conta? Cadastre-se")
                        .font(AppFont.pokemonDetail())
                        .foregroundColor(AppColor.primary)
                }
            }
            .padding(AppSpacing.large)
            .navigationDestination(isPresented: $showingRegisterView) {
                RegisterView()
            }
            .alert("Erro de Login", isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    private func loginUser() {
        print("➡️ [LoginView] 1. Botão de login pressionado.")
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Nome de usuário e senha são obrigatórios."
            showingAlert = true
            return
        }
        
        do {
            print("➡️ [LoginView] 2. Chamando AuthService.login...")
            try AuthService.login(username: username, passwordHash: password, in: modelContext)
            
            print("✅ [LoginView] 3. Login bem-sucedido na View.")
            isUserLoggedIn = true
            loggedInUsername = username
        } catch {
            print("❌ [LoginView] 3. Erro capturado do AuthService: \(error.localizedDescription)")
            alertMessage = error.localizedDescription
            showingAlert = true
        }
    }
}
