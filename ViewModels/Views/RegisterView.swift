import SwiftUI

struct RegisterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: AppSpacing.large) {
            Spacer()
            
            Text("Criar Conta")
                .font(AppFont.pokemonTitle())
                .padding(.bottom, AppSpacing.large)
            
            VStack(spacing: AppSpacing.medium) {
                TextField("Nome de usuário", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                
                SecureField("Senha", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirmar Senha", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .frame(maxWidth: 480) // <-- MUDANÇA APLICADA AQUI
            
            Button(action: registerUser) {
                Text("Cadastrar")
                    .font(AppFont.pokemonBody().bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColor.primary)
                    .cornerRadius(12)
            }
            .frame(maxWidth: 480) // E no botão também
            
            Spacer()
        }
        .padding(AppSpacing.large)
        .alert("Erro de Cadastro", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
        .navigationTitle("Cadastro")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func registerUser() {
        guard !username.isEmpty, !password.isEmpty else {
            alertMessage = "Usuário e senha são obrigatórios."
            showingAlert = true
            return
        }
        
        guard password == confirmPassword else {
            alertMessage = "As senhas não coincidem."
            showingAlert = true
            return
        }
        
        do {
            try AuthService.register(username: username, passwordHash: password, in: modelContext)
            dismiss()
        } catch {
            alertMessage = "Este nome de usuário já existe. Por favor, escolha outro."
            showingAlert = true
        }
    }
}
