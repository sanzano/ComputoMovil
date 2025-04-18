//
//  MainTabView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI

struct MainTabView: View {
    // Estado para seleccionar la pestaña inicial (Activities)
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Pestaña 1: Feed
            FeedView()
                .tabItem {
                    Label("Inicio", systemImage: "house.fill")
                }
                .tag(0)
            
            // Pestaña 2: Activities (Vista inicial)
            ActivitiesView()
                .tabItem {
                    Label("Actividades", systemImage: "calendar")
                }
                .tag(1)
            
            // Pestaña 3: Perfil
            ProfileView()
                .tabItem {
                    Label("Perfil", systemImage: "person.fill")
                }
                .tag(2)
        }
        .accentColor(.blue) // Color del ícono seleccionado
    }
}
