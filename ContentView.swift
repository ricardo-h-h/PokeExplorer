import SwiftUI

struct ContentView: View {
    @AppStorage("isUserLoggedIn") private var isUserLoggedIn: Bool = false
    
    var body: some View {
        if isUserLoggedIn {
            MainTabView()
        } else {
            LoginView()
        }
    }
}

// O Preview também precisa do import, mas geralmente o Xcode o adiciona.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
