//
//  YaQuedamosApp.swift
//  YaQuedamos
//
//  Created by Alumno on 03/04/25.
//

import SwiftUI

@main
struct YaQuedamosApp: App {
    var body: some Scene {
        WindowGroup {
            // Cambia esto por tu vista principal de actividades
            SplashScreenView() // ← Este es el punto de entrada principal
                .environment(\.colorScheme, .light) // Opcional: estilo de color
        }
    }
}
