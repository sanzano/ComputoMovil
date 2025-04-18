//
//  SplashScreenView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false // Controla cuándo ocultar la splash
    @State private var scale = 0.7      // Para efecto de escala
    @State private var opacity = 0.5    // Para efecto de fade
    
    var body: some View {
        if isActive {
            MainTabView() // Muestra el TabView después de la splash
        } else {
            ZStack {
                Color("BrandPrimary") // Fondo (puede ser blanco, negro o un color personalizado)
                    .ignoresSafeArea()
                
                // --- Contenido de la splash (personaliza esto) ---
                Image("hola") // Reemplaza con tu imagen en Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .scaleEffect(scale)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.2)) {
                            scale = 1.0
                            opacity = 1.0
                        }
                    }
            }
            .onAppear {
                // Simula un tiempo de carga (3 segundos)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}
