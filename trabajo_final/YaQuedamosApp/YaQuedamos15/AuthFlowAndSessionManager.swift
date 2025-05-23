//
//  AuthFlowAndSessionManager.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI

/// Maneja el estado de la sesión y decide el flujo de la app
enum AppFlow { case launch, auth, home }

final class SessionManager: ObservableObject {
    @Published var flow: AppFlow = .launch
    private let key = "UsuarioRegistrado"

    /// Resuelve si mostrar login o la app principal
    func resolveFlow() {
        let existe = UserDefaults.standard.bool(forKey: key)
        flow = existe ? .home : .auth
    }

    /// Llamar al iniciar sesión exitosamente
    func signIn() {
        UserDefaults.standard.set(true, forKey: key)
        flow = .home
    }

    /// Llamar al registrarse
    func signUp() {
        UserDefaults.standard.set(true, forKey: key)
        flow = .home
    }

    /// Cierra sesión
    func signOut() {
        UserDefaults.standard.set(false, forKey: key)
        flow = .auth
    }
}

/// Flow de autenticación: alterna entre login y signup
struct AuthFlow: View {
    @EnvironmentObject var session: SessionManager
    @State private var isNewUser = false

    var body: some View {
        VStack {
            if isNewUser {
                SignUpView(onDone: { isNewUser = false })
                    .transition(.move(edge: .trailing))
            } else {
                LoginView(onCreate: { isNewUser = true })
                    .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isNewUser)
    }
}

/// Vista de login
struct LoginView: View {
    @EnvironmentObject var session: SessionManager
    @State private var email = ""
    @State private var password = ""

    var onCreate: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Iniciar Sesión")
                .font(.title2).bold()
            TextField("Correo electrónico", text: $email)
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: { session.signIn() }) {
                Text("Entrar")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(action: onCreate) {
                Text("Crear cuenta nueva")
                    .font(.footnote)
            }
        }
        .padding()
    }
}

/// Vista de registro
struct SignUpView: View {
    @EnvironmentObject var session: SessionManager
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var onDone: () -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Registro")
                .font(.title2).bold()
            TextField("Nombre completo", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Correo electrónico", text: $email)
                .textInputAutocapitalization(.never)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Contraseña", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: { session.signUp() }) {
                Text("Registrar")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)

            Button(action: onDone) {
                Text("Ya tengo cuenta")
                    .font(.footnote)
            }
        }
        .padding()
    }
}

// MARK: - Previews

struct AuthFlow_Previews: PreviewProvider {
    static var previews: some View {
        AuthFlow()
            .environmentObject(SessionManager())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(onCreate: {})
            .environmentObject(SessionManager())
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(onDone: {})
            .environmentObject(SessionManager())
    }
}
