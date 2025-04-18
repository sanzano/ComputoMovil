//
//  ActivitiesView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI

struct ActivitiesView: View {
    @State private var activities: [Activity] = []
    @State private var showingCreateActivity = false
    @State private var selectedCategory: ActivityCategory? = nil
    @State private var searchText: String = ""
    
    // Categorías para el filtro
    private var allCategories = ActivityCategory.allCases
    
    // Actividades filtradas
    private var filteredActivities: [Activity] {
        activities.filter { activity in
            (selectedCategory == nil || activity.category == selectedCategory) &&
            (searchText.isEmpty || activity.name.localizedCaseInsensitiveContains(searchText))
        }
    }
    
    // Tus actividades (simuladas)
    private var yourActivities: [Activity] {
        activities.filter { $0.organizer == "san_sanchez" }
    }
    
    // Próximas actividades
    private var upcomingActivities: [Activity] {
        activities.filter { $0.isUpcoming && $0.organizer != "san_sanchez" }
    }
    
    // Actividades recomendadas
    private var recommendedActivities: [Activity] {
        activities.filter { $0.category == .deportes || $0.category == .juegos }.shuffled().prefix(3).map { $0 }
    }
    
    // Actividades cercanas
    private var nearbyActivities: [Activity] {
        activities.filter { _ in Bool.random() } // Simulación de cercanía
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Barra de búsqueda
                    searchBar
                        .padding(.horizontal, 16)
                    
                    // Filtros por categoría
                    categoryFilter
                        .padding(.horizontal, 16)
                    
                    // Tus actividades
                    if !yourActivities.isEmpty {
                        activitiesSection(title: "Tus Actividades", activities: yourActivities)
                    }
                    
                    // Próximas actividades
                    activitiesSection(title: "Próximas actividades", activities: upcomingActivities)
                    
                    // Recomendadas
                    if !recommendedActivities.isEmpty {
                        activitiesSection(title: "Para ti", activities: recommendedActivities)
                    }
                    
                    // Cercanas
                    if !nearbyActivities.isEmpty {
                        activitiesSection(title: "Cerca de ti", activities: nearbyActivities)
                    }
                    
                    // Todas las actividades
                    activitiesSection(title: "Todas las actividades", activities: filteredActivities)
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Actividades")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingCreateActivity = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(Color("BrandPrimary"))
                    }
                }
            }
            .sheet(isPresented: $showingCreateActivity) {
                CreateActivityView()
                    .presentationDetents([.medium, .large])
            }
            .onAppear {
                loadSampleActivities()
            }
        }
    }
    
    // MARK: - Componentes de la vista
    
    private var searchBar: some View {
        HStack {
            TextField("Buscar actividades", text: $searchText)
                .padding(12)
                .padding(.leading, 32)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 12)
                    }
                )
            
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button(action: {
                    selectedCategory = nil
                }) {
                    Text("Todos")
                        .font(.system(size: 14, weight: selectedCategory == nil ? .semibold : .regular))
                        .foregroundColor(selectedCategory == nil ? .white : Color("BrandPrimary"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selectedCategory == nil ? Color("BrandPrimary") : Color("BrandPrimary").opacity(0.2))
                        .cornerRadius(16)
                }
                
                ForEach(allCategories, id: \.self) { category in
                    Button(action: {
                        selectedCategory = category
                    }) {
                        Text(category.rawValue)
                            .font(.system(size: 14, weight: selectedCategory == category ? .semibold : .regular))
                            .foregroundColor(selectedCategory == category ? .white : Color("BrandPrimary"))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(selectedCategory == category ? Color("BrandPrimary") : Color("BrandPrimary").opacity(0.2))
                            .cornerRadius(16)
                    }
                }
            }
        }
    }
    
    private func activitiesSection(title: String, activities: [Activity]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                
                Spacer()
                
                if activities.count > 3 {
                    NavigationLink(destination: AllActivitiesView(title: title, activities: activities)) {
                        Text("Ver todas")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(Color("BrandPrimary"))
                    }
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(activities.prefix(3)) { activity in
                        NavigationLink(destination: ActivityDetailView(activity: activity)) {
                            activityCard(activity: activity)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
    
    private func activityCard(activity: Activity) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            // Imagen de la actividad (placeholder)
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .aspectRatio(1.5, contentMode: .fill)
                    .frame(width: 220)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.system(size: 32))
                            .foregroundColor(.white.opacity(0.5))
                    )
                
                // Categoría
                Text(activity.category.rawValue)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color("BrandPrimary"))
                    .cornerRadius(4)
                    .padding(8)
            }
            
            // Información de la actividad
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(1)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12))
                    Text(activity.location)
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(activity.formattedDate)
                        .font(.system(size: 14))
                }
                .foregroundColor(.secondary)
                
                HStack {
                    // Asistentes
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text("\(activity.currentAttendees)/\(activity.maxAttendees)")
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    // Nivel de habilidad
                    Text(activity.skillLevel.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .frame(width: 220)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    // MARK: - Datos de ejemplo
    
    private func loadSampleActivities() {
        let now = Date()
        let calendar = Calendar.current
        
        activities = [
            // Tus actividades
            Activity(
                id: UUID(),
                name: "Partido de fútbol sabatino",
                description: "Partido amistoso en parque central, todos los sábados",
                location: "Parque Central",
                date: calendar.date(byAdding: .day, value: 2, to: now)!,
                category: .deportes,
                currentAttendees: 5,
                maxAttendees: 10,
                isPublic: true,
                ageRestriction: 16,
                genderRestriction: nil,
                recurrence: .semanal,
                requirements: ["Traer balón", "Ropa deportiva"],
                skillLevel: .intermedio,
                organizer: "san_sanchez",
                hasCost: false,
                costAmount: nil,
                chatId: "chat1",
                latitude: 19.4326,
                longitude: -99.1332
            ),
            
            // Próximas actividades
            Activity(
                id: UUID(),
                name: "Clase de yoga matutino",
                description: "Clase de yoga para todos los niveles en el parque",
                location: "Parque de la Ciudad",
                date: calendar.date(byAdding: .day, value: 1, to: now)!,
                category: .deportes,
                currentAttendees: 8,
                maxAttendees: 15,
                isPublic: true,
                ageRestriction: nil,
                genderRestriction: nil,
                recurrence: .diaria,
                requirements: ["Traer tapete"],
                skillLevel: .todos,
                organizer: "YogaEnParque",
                hasCost: true,
                costAmount: 50,
                chatId: "chat2",
                latitude: 19.4285,
                longitude: -99.1276
            ),
            
            Activity(
                id: UUID(),
                name: "Torneo de ajedrez",
                description: "Torneo amistoso de ajedrez en la biblioteca",
                location: "Biblioteca Central",
                date: calendar.date(byAdding: .day, value: 3, to: now)!,
                category: .juegos,
                currentAttendees: 12,
                maxAttendees: 20,
                isPublic: true,
                ageRestriction: 12,
                genderRestriction: nil,
                recurrence: .unica,
                requirements: [],
                skillLevel: .todos,
                organizer: "ClubAjedrez",
                hasCost: false,
                costAmount: nil,
                chatId: "chat3",
                latitude: 19.4342,
                longitude: -99.1403
            ),
            
            // Más actividades
            Activity(
                id: UUID(),
                name: "Carrera 5K benéfica",
                description: "Carrera para recaudar fondos para organización local",
                location: "Paseo de la Reforma",
                date: calendar.date(byAdding: .day, value: 7, to: now)!,
                category: .deportes,
                currentAttendees: 45,
                maxAttendees: 100,
                isPublic: true,
                ageRestriction: nil,
                genderRestriction: nil,
                recurrence: .unica,
                requirements: ["Registro previo"],
                skillLevel: .todos,
                organizer: "FundaciónCorre",
                hasCost: true,
                costAmount: 200,
                chatId: "chat4",
                latitude: 19.4260,
                longitude: -99.1508
            ),
            
            Activity(
                id: UUID(),
                name: "Taller de pintura al óleo",
                description: "Aprende técnicas básicas de pintura al óleo",
                location: "Centro Cultural",
                date: calendar.date(byAdding: .day, value: 5, to: now)!,
                category: .arte,
                currentAttendees: 6,
                maxAttendees: 12,
                isPublic: true,
                ageRestriction: 18,
                genderRestriction: nil,
                recurrence: .semanal,
                requirements: ["Materiales incluidos"],
                skillLevel: .principiante,
                organizer: "ArteLocal",
                hasCost: true,
                costAmount: 350,
                chatId: "chat5",
                latitude: 19.4312,
                longitude: -99.1379
            ),
            
            Activity(
                id: UUID(),
                name: "Voluntariado en banco de alimentos",
                description: "Ayuda a clasificar y empacar alimentos para comunidades necesitadas",
                location: "Banco de Alimentos CDMX",
                date: calendar.date(byAdding: .day, value: 4, to: now)!,
                category: .voluntariado,
                currentAttendees: 15,
                maxAttendees: 25,
                isPublic: true,
                ageRestriction: 16,
                genderRestriction: nil,
                recurrence: .mensual,
                requirements: ["Ropa cómoda"],
                skillLevel: .todos,
                organizer: "BancoAlimentos",
                hasCost: false,
                costAmount: nil,
                chatId: "chat6",
                latitude: 19.4387,
                longitude: -99.1445
            )
        ]
    }
}

// MARK: - Vistas auxiliares

struct AllActivitiesView: View {
    let title: String
    let activities: [Activity]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(activities) { activity in
                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                        activityCard(activity: activity)
                            .padding(.horizontal, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.vertical, 16)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func activityCard(activity: Activity) -> some View {
        HStack(alignment: .top, spacing: 12) {
            // Imagen de la actividad (placeholder)
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.5))
                )
            
            // Información de la actividad
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(activity.name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Text(activity.category.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color("BrandPrimary").opacity(0.2))
                        .cornerRadius(4)
                }
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.and.ellipse")
                        .font(.system(size: 12))
                    Text(activity.location)
                        .font(.system(size: 14))
                }
                .foregroundColor(.secondary)
                
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                    Text(activity.formattedDate)
                        .font(.system(size: 14))
                }
                .foregroundColor(.secondary)
                
                HStack {
                    // Asistentes
                    HStack(spacing: 4) {
                        Image(systemName: "person.2.fill")
                            .font(.system(size: 12))
                        Text("\(activity.currentAttendees)/\(activity.maxAttendees)")
                            .font(.system(size: 14))
                    }
                    
                    Spacer()
                    
                    // Nivel de habilidad
                    Text(activity.skillLevel.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Previews

struct ActivitiesView_Previews: PreviewProvider {
    static var previews: some View {
        ActivitiesView()
    }
}
