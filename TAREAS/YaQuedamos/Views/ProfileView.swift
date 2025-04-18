//
//  ContentView.swift
//  YaQuedamos
//
//  Created by Alumno on 03/04/25.

import SwiftUI

// Modelo de datos para Grupos
struct AltGroup: Identifiable {
    let id = UUID()
    let name: String
    let members: Int
    let activitiesThisWeek: Int
    let score: Int
    let iconName: String
    let isJoined: Bool
}

struct ProfileView: View {
    @State private var selectedTab: ProfileTab = .activities
    @State private var showEditProfile = false
    @State private var userScore: Int = 875 // Puntaje del usuario
    
    // Datos de grupos distintos
    @State private var groups: [AltGroup] = [
        AltGroup(name: "Corredores CDMX", members: 1250, activitiesThisWeek: 5, score: 125, iconName: "figure.run", isJoined: true),
        AltGroup(name: "Fútbol Sabatino", members: 850, activitiesThisWeek: 2, score: 75, iconName: "soccerball", isJoined: true),
        AltGroup(name: "Yoga en el Parque", members: 320, activitiesThisWeek: 7, score: 210, iconName: "figure.yoga", isJoined: false),
        AltGroup(name: "Ciclismo Urbano", members: 670, activitiesThisWeek: 3, score: 95, iconName: "bicycle", isJoined: true),
        AltGroup(name: "Senderismo", members: 430, activitiesThisWeek: 1, score: 60, iconName: "figure.hiking", isJoined: false)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header con foto de perfil y fondo
                    profileHeader
                    
                    // Información del usuario
                    userInfoSection
                        .padding(.horizontal, 24)
                    
                    // Estadísticas
                    statsSection
                        .padding(.top, 16)
                        .padding(.horizontal, 24)
                    
                    // Bio y botones de acción
                    actionSection
                        .padding(.top, 16)
                        .padding(.horizontal, 24)
                    
                    // Pestañas de contenido
                    tabSelector
                        .padding(.top, 24)
                    
                    // Contenido según pestaña seleccionada
                    tabContent
                        .padding(.horizontal, 24)
                        .padding(.bottom, 80)
                }
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("san_sanchez")
                        .font(.system(size: 18, weight: .bold))
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showEditProfile = true }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
            .sheet(isPresented: $showEditProfile) {
                EditProfileView()
                    .presentationDetents([.medium, .large])
            }
        }
    }
    
    // MARK: - Componentes de la vista
    
    private var profileHeader: some View {
        ZStack(alignment: .bottomTrailing) {
            // Foto de portada
            LinearGradient(gradient: Gradient(colors: [Color("BrandPrimary"), Color.blue]),
                          startPoint: .topLeading, endPoint: .bottomTrailing)
                .frame(height: 220)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.3))
                )
            
            // Foto de perfil
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                        
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundColor(.gray.opacity(0.3))
                            .overlay(
                                Text("SS")
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            )
                    }
                    .offset(y: 60)
                    .padding(.trailing, 24)
                }
            }
            .frame(height: 220)
        }
    }
    
    private var userInfoSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("San Sánchez")
                .font(.system(size: 28, weight: .bold))
                .padding(.top, 40)
            
            HStack(spacing: 16) {
                Image(systemName: "mappin.and.ellipse")
                Text("Ciudad de México")
                
                // Puntaje del usuario
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(userScore)")
                        .font(.system(size: 16, weight: .semibold))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(12)
            }
            .font(.system(size: 16))
            .foregroundColor(.secondary)
            .padding(.top, 4)
        }
    }
    
    private var statsSection: some View {
        HStack(spacing: 16) {
            statItem(value: "672", label: "Actividades")
            Divider().frame(height: 40)
            statItem(value: "225K", label: "Amigos")
            Divider().frame(height: 40)
            
            // Grupo con puntaje
            VStack(spacing: 4) {
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(groups.count)")
                        .font(.system(size: 20, weight: .semibold))
                    
                    // Indicador de puntaje en grupos
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text("+25")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(8)
                }
                
                Text("Grupos")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 20, weight: .semibold))
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }
    
    private var actionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Amante de los deportes de contacto. Buscando compañeros para jugar fútbol y correr.")
                .font(.system(size: 16))
                .lineSpacing(4)
            
            if let url = URL(string: "https://www.yaquedamos.com/careers/") {
                Link(destination: url) {
                    HStack(spacing: 4) {
                        Image(systemName: "link")
                        Text("yaguedamos.com/careers")
                            .lineLimit(1)
                    }
                    .font(.system(size: 16))
                    .foregroundColor(Color("BrandPrimary"))
                }
            }
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Seguir")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("BrandPrimary"))
                        .cornerRadius(12)
                }
                
                Button(action: {}) {
                    Image(systemName: "ellipsis.message")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(Color("BrandPrimary"))
                        .frame(width: 50, height: 50)
                        .background(Color("BrandPrimary").opacity(0.2))
                        .cornerRadius(12)
                }
            }
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(ProfileTab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation {
                        selectedTab = tab
                    }
                }) {
                    VStack(spacing: 8) {
                        Text(tab.rawValue)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(selectedTab == tab ? .primary : .secondary)
                        
                        if selectedTab == tab {
                            Capsule()
                                .frame(height: 3)
                                .foregroundColor(Color("BrandPrimary"))
                        } else {
                            Divider().opacity(0)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 24)
        .background(
            Divider()
                .background(Color.gray.opacity(0.3)),
            alignment: .bottom
        )
    }
    
    @ViewBuilder
    private var tabContent: some View {
        switch selectedTab {
        case .activities:
            activitiesTab
        case .groups:
            groupsTab
        case .achievements:
            achievementsTab
        }
    }
    
    private var activitiesTab: some View {
        VStack(spacing: 24) {
            // Gráfico de actividad
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Tu actividad esta semana")
                        .font(.system(size: 18, weight: .semibold))
                    
                    Spacer()
                    
                    Text("1 hora")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                
                activityChart
                    .frame(height: 200)
                
                Text("Actividades Creadas")
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.top, 8)
            }
            
            // Actividad reciente
            recentActivityCard
        }
        .padding(.top, 16)
    }
    
    private var activityChart: some View {
        VStack(spacing: 0) {
            // Barras del gráfico
            HStack(alignment: .bottom, spacing: 16) {
                ForEach(0..<7) { day in
                    VStack(spacing: 4) {
                        let height = CGFloat.random(in: 0.1...1.0)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .frame(width: 24, height: 150 * height)
                            .foregroundColor(Color("BrandPrimary"))
                        
                        Text("\(Int(height * 100))%")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(height: 150)
            
            // Días de la semana
            HStack(spacing: 0) {
                ForEach(["L", "M", "M", "J", "V", "S", "D"], id: \.self) { day in
                    Text(day)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.top, 8)
        }
    }
    
    private var recentActivityCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Circle()
                    .frame(width: 48, height: 48)
                    .foregroundColor(.gray.opacity(0.3))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("san_sanchez")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Miércoles, 2 de abril 2025")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis")
                    .foregroundColor(.secondary)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Deporte Matutino")
                    .font(.system(size: 18, weight: .semibold))
                
                Text("Continuando la semana con un poco de cardio por el parque. ¡Increíble día para ejercitarse!")
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                
                // Mini galería de fotos
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(1...3, id: \.self) { _ in
                            RoundedRectangle(cornerRadius: 8)
                                .frame(width: 120, height: 120)
                                .foregroundColor(.gray.opacity(0.3))
                                .overlay(
                                    Image(systemName: "photo")
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        }
                    }
                }
                .padding(.top, 8)
            }
            
            HStack(spacing: 24) {
                statItem(value: "50 min", label: "Tiempo")
                statItem(value: "1,880 kg", label: "Volumen")
                statItem(value: "1", label: "Retos")
            }
            .padding(.top, 8)
            
            // Acciones de la publicación
            HStack(spacing: 16) {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                        Text("125")
                    }
                }
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.left")
                        Text("23")
                    }
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "bookmark")
                }
            }
            .foregroundColor(.secondary)
            .font(.system(size: 14, weight: .medium))
            .padding(.top, 8)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var groupsTab: some View {
        VStack(spacing: 16) {
            ForEach(groups) { group in
                groupCard(group: group)
            }
        }
        .padding(.top, 16)
    }
    
    private func groupCard(group: AltGroup) -> some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray.opacity(0.3))
                .overlay(
                    Image(systemName: group.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.7))
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(group.name)
                        .font(.system(size: 16, weight: .semibold))
                    
                    // Puntaje del grupo
                    HStack(spacing: 2) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                        Text("\(group.score)")
                            .font(.system(size: 12, weight: .semibold))
                    }
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.yellow.opacity(0.2))
                    .cornerRadius(8)
                }
                
                Text("\(group.members.formatted()) miembros • \(group.activitiesThisWeek) actividades esta semana")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text(group.isJoined ? "Unido" : "Unirse")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(group.isJoined ? Color("BrandPrimary") : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(group.isJoined ? Color("BrandPrimary").opacity(0.2) : Color("BrandPrimary"))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
    
    private var achievementsTab: some View {
        VStack(spacing: 24) {
            achievementProgress(title: "Socializador", progress: 0.75, description: "Participa en 50 actividades", imageName: "person.3.fill")
            
            achievementProgress(title: "Deportista", progress: 0.4, description: "Completa 100 horas de deporte", imageName: "figure.run")
            
            achievementProgress(title: "Líder", progress: 0.9, description: "Organiza 10 actividades", imageName: "star.fill")
        }
        .padding(.top, 16)
    }
    
    private func achievementProgress(title: String, progress: Double, description: String, imageName: String) -> some View {
        HStack(spacing: 16) {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(Color("BrandPrimary").opacity(0.2))
                .overlay(
                    Image(systemName: imageName)
                        .font(.system(size: 24))
                        .foregroundColor(Color("BrandPrimary"))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Spacer()
                    
                    Text("\(Int(progress * 100))%")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color("BrandPrimary"))
                }
                
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: Color("BrandPrimary")))
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

// MARK: - Enums y Vistas Adicionales

enum ProfileTab: String, CaseIterable {
    case activities = "Actividades"
    case groups = "Grupos"
    case achievements = "Logros"
}

struct EditProfileView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Contenido del editor de perfil...
                    Text("Configuración de perfil")
                }
                .padding()
            }
            .navigationTitle("Editar Perfil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Listo") {}
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
