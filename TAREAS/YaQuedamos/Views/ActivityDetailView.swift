//
//  ActivityDetailView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI
import MapKit

struct ActivityDetailView: View {
    let activity: Activity
    @State private var showingInviteView = false
    @State private var showingChat = false
    @State private var position: MapCameraPosition
    
    init(activity: Activity) {
        self.activity = activity
        let coordinate = CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude)
        self._position = State(initialValue: .region(MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header con imagen
                activityHeader
                
                // Contenido principal
                VStack(alignment: .leading, spacing: 24) {
                    // Información básica
                    basicInfoSection
                    
                    // Detalles de la actividad
                    detailsSection
                    
                    // Restricciones y requerimientos
                    restrictionsSection
                    
                    // Mapa de ubicación
                    locationSection
                    
                    // Acciones
                    actionButtons
                }
                .padding()
            }
        }
        .navigationTitle("Detalles")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingInviteView) {
            InviteFriendsView(activity: activity)
        }
        .sheet(isPresented: $showingChat) {
            ActivityChatView(chatId: activity.chatId)
        }
    }
    
    // MARK: - Componentes de la vista
    
    private var activityHeader: some View {
        ZStack(alignment: .bottomLeading) {
            // Imagen de la actividad (placeholder)
            Rectangle()
                .foregroundColor(Color.gray.opacity(0.3))
                .frame(height: 220)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 48))
                        .foregroundColor(.white.opacity(0.5))
                )
            
            // Categoría y nivel
            HStack {
                Text(activity.category.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color("BrandPrimary"))
                    .cornerRadius(16)
                
                Text(activity.skillLevel.rawValue)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(16)
            }
            .padding()
        }
    }
    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(activity.name)
                .font(.system(size: 28, weight: .bold))
            
            Text(activity.description)
                .font(.system(size: 16))
                .lineSpacing(6)
            
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Información rápida
            HStack(spacing: 24) {
                detailItem(icon: "mappin.and.ellipse", label: activity.location)
                detailItem(icon: "calendar", label: activity.formattedDate)
                detailItem(icon: "person.2", label: "\(activity.currentAttendees)/\(activity.maxAttendees)")
            }
        }
    }
    
    private var detailsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalles de la actividad")
                .font(.system(size: 20, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 12) {
                detailRow(icon: "person.crop.square", label: "Organizador", value: activity.organizer)
                detailRow(icon: activity.isPublic ? "globe" : "lock", label: "Visibilidad", value: activity.isPublic ? "Pública" : "Privada")
                detailRow(icon: "arrow.clockwise", label: "Recurrencia", value: activity.recurrence.rawValue)
                
                if activity.hasCost {
                    detailRow(icon: "dollarsign.circle", label: "Costo", value: activity.costAmount?.formatted(.currency(code: "MXN")) ?? "Gratis")
                } else {
                    detailRow(icon: "dollarsign.circle", label: "Costo", value: "Gratis")
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var restrictionsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Requisitos y restricciones")
                .font(.system(size: 20, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 12) {
                if let age = activity.ageRestriction {
                    detailRow(icon: "number", label: "Edad mínima", value: "\(age)+ años")
                }
                
                if let gender = activity.genderRestriction {
                    detailRow(icon: "person.2", label: "Género", value: gender)
                }
                
                if !activity.requirements.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "checklist")
                                .foregroundColor(.secondary)
                            Text("Requerimientos:")
                                .font(.system(size: 16, weight: .medium))
                            Spacer()
                        }
                        
                        ForEach(activity.requirements, id: \.self) { req in
                            HStack {
                                Circle()
                                    .frame(width: 6, height: 6)
                                    .foregroundColor(Color("BrandPrimary"))
                                Text(req)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
        }
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Ubicación")
                .font(.system(size: 20, weight: .semibold))
            
            Map(position: $position) {
                Marker(activity.name, coordinate: CLLocationCoordinate2D(
                    latitude: activity.latitude,
                    longitude: activity.longitude
                ))
            }
            .mapStyle(.standard)
            .frame(height: 200)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            Button(action: {
                // Abrir en Maps
                let url = URL(string: "http://maps.apple.com/?ll=\(activity.latitude),\(activity.longitude)&q=\(activity.location.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")")!
                UIApplication.shared.open(url)
            }) {
                HStack {
                    Image(systemName: "arrow.triangle.turn.up.right.diamond")
                    Text("Cómo llegar")
                }
                .font(.system(size: 16, weight: .medium))
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
    }
    
    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: {
                // Lógica para unirse
            }) {
                Text("Unirse a la actividad")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color("BrandPrimary"))
            
            HStack(spacing: 12) {
                Button(action: {
                    showingInviteView = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "person.badge.plus")
                        Text("Invitar")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .buttonStyle(.bordered)
                .tint(Color("BrandPrimary"))
                
                Button(action: {
                    showingChat = true
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "message")
                        Text("Chat")
                    }
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                }
                .buttonStyle(.bordered)
                .tint(Color("BrandPrimary"))
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Componentes auxiliares
    
    private func detailItem(icon: String, label: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(Color("BrandPrimary"))
            Text(label)
                .font(.system(size: 15, weight: .medium))
        }
    }
    
    private func detailRow(icon: String, label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Image(systemName: icon)
                .foregroundColor(.secondary)
                .frame(width: 24)
            Text(label + ":")
                .font(.system(size: 16, weight: .medium))
            Text(value)
                .font(.system(size: 16))
            Spacer()
        }
    }
}

// MARK: - Vistas Auxiliares

struct InviteFriendsView: View {
    let activity: Activity
    @State private var searchText = ""
    @State private var selectedFriends: [String] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(friends.filter {
                        searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self) { friend in
                        HStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .overlay(
                                    Text(friend.prefix(1))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            Text(friend)
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            if selectedFriends.contains(friend) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(Color("BrandPrimary"))
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            if selectedFriends.contains(friend) {
                                selectedFriends.removeAll { $0 == friend }
                            } else {
                                selectedFriends.append(friend)
                            }
                        }
                    }
                } header: {
                    TextField("Buscar amigos", text: $searchText)
                        .padding(8)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.bottom, 8)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Invitar amigos")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Enviar") {
                        dismiss()
                    }
                    .disabled(selectedFriends.isEmpty)
                }
            }
        }
    }
    
    // Datos de ejemplo
    private let friends = ["Carlos M.", "Ana L.", "Miguel R.", "Sofía G.", "David H."]
}

struct ActivityChatView: View {
    let chatId: String
    @State private var message = ""
    @State private var messages: [ChatMessage] = []
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(messages) { message in
                                chatBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: messages) { _, newMessages in
                        if let lastMessage = newMessages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                Divider()
                
                HStack {
                    TextField("Escribe un mensaje...", text: $message)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 8)
                    
                    Button(action: sendMessage) {
                        Image(systemName: "paperplane.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color("BrandPrimary"))
                            .padding(8)
                    }
                    .disabled(message.isEmpty)
                }
                .padding()
            }
            .navigationTitle("Chat de actividad")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Listo") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                loadSampleMessages()
            }
        }
    }
    
    private func chatBubble(message: ChatMessage) -> some View {
        HStack {
            if message.isCurrentUser {
                Spacer()
            }
            
            VStack(alignment: message.isCurrentUser ? .trailing : .leading, spacing: 4) {
                Text(message.text)
                    .padding(12)
                    .background(message.isCurrentUser ? Color("BrandPrimary") : Color.gray.opacity(0.2))
                    .foregroundColor(message.isCurrentUser ? .white : .primary)
                    .cornerRadius(12)
                
                Text(message.timestamp)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if !message.isCurrentUser {
                Spacer()
            }
        }
    }
    
    private func sendMessage() {
        guard !message.isEmpty else { return }
        let newMessage = ChatMessage(
            id: UUID(),
            text: message,
            timestamp: Date().formatted(date: .omitted, time: .shortened),
            isCurrentUser: true
        )
        messages.append(newMessage)
        message = ""
    }
    
    private func loadSampleMessages() {
        messages = [
            ChatMessage(
                id: UUID(),
                text: "¡Hola a todos! ¿Listos para la actividad?",
                timestamp: "10:30 AM",
                isCurrentUser: false
            ),
            ChatMessage(
                id: UUID(),
                text: "¡Claro que sí! ¿Qué necesitamos llevar?",
                timestamp: "10:32 AM",
                isCurrentUser: true
            ),
            ChatMessage(
                id: UUID(),
                text: "Solo traigan ropa cómoda y agua. Nosotros proveemos el resto del equipo.",
                timestamp: "10:33 AM",
                isCurrentUser: false
            ),
            ChatMessage(
                id: UUID(),
                text: "Perfecto, ahí nos vemos.",
                timestamp: "10:35 AM",
                isCurrentUser: true
            )
        ]
    }
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let text: String
    let timestamp: String
    let isCurrentUser: Bool
    
    static func == (lhs: ChatMessage, rhs: ChatMessage) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Previews

struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleActivity = Activity(
            id: UUID(),
            name: "Partido de fútbol sabatino",
            description: "Partido amistoso en parque central, todos los sábados. Vamos a jugar en equipos mixtos y al final tomaremos algo juntos.",
            location: "Parque Central, CDMX",
            date: Date().addingTimeInterval(86400 * 2),
            category: .deportes,
            currentAttendees: 5,
            maxAttendees: 10,
            isPublic: true,
            ageRestriction: 16,
            genderRestriction: nil,
            recurrence: .semanal,
            requirements: ["Traer balón", "Ropa deportiva", "Agua"],
            skillLevel: .intermedio,
            organizer: "Carlos M.",
            hasCost: false,
            costAmount: nil,
            chatId: "chat1",
            latitude: 19.4326,
            longitude: -99.1332
        )
        
        ActivityDetailView(activity: sampleActivity)
    }
}
