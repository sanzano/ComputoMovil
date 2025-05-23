//
//  SessionManager.swift
//  YaQuedamos
//
//  Created by Alumno on 05/05/25.
//

import Foundation
import SwiftUI

/// Define los posibles flujos de la app
enum AppFlow {
    case launch, auth, home
}

/// Maneja el estado de la sesión y decide qué vista mostrar
final class SessionManager: ObservableObject {
    @Published var flow: AppFlow = .launch
    private let key = "UsuarioRegistrado"

    /// Llamar desde la Splash para decidir auth vs home
    func resolveFlow() {
        let existe = UserDefaults.standard.bool(forKey: key)
        flow = existe ? .home : .auth
    }

    /// Iniciar sesión: muestra la splash de nuevo y después va a home
    func signIn() {
        UserDefaults.standard.set(true, forKey: key)
        flow = .launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.flow = .home
        }
    }

    /// Registrarse: igual que signIn
    func signUp() {
        UserDefaults.standard.set(true, forKey: key)
        flow = .launch
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.flow = .home
        }
    }

    /// Cerrar sesión
    func signOut() {
        UserDefaults.standard.set(false, forKey: key)
        flow = .auth
    }
}
