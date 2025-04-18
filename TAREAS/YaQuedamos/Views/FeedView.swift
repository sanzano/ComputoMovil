//
//  FeedView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI

// Modelo de datos para Notificaciones
struct Notificacion: Identifiable {
    let id = UUID()
    let tipo: TipoNotificacion
    let usuario: String?
    let actividad: String?
    let mensaje: String
    let tiempo: String
    var leida: Bool
    let imagenURL: String?
    
    enum TipoNotificacion {
        case recordatorio
        case invitacion
        case logro
        case sistema
    }
}

// Modelo de datos para Publicaciones (actualizado)
struct Publicacion: Identifiable {
    let id = UUID()
    let usuario: String
    let titulo: String
    let descripcion: String
    let tiempo: String
    let volumen: String
    let tieneImagen: Bool
    let comentarios: [Comentario]
    let estado: EstadoActividad
    let horaInicio: Date?
    let horaFin: Date?
    
    enum EstadoActividad {
        case concluida
        case enCurso
        case proximamente
    }
}

struct Comentario {
    let usuario: String
    let texto: String
}

// Extensión para formatear fechas
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func formattedHour() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: self)
    }
}

// Vista principal
struct FeedView: View {
    // Estados para publicaciones
    @State private var postsLiked = [Bool](repeating: false, count: 10)
    @State private var conteoLikes = [15, 42, 28, 33, 19, 24, 37, 41, 12, 29]
    @State private var postsGuardados = [Bool](repeating: false, count: 10)
    @State private var mostrarComentarios = false
    @State private var publicacionSeleccionada = 0
    @State private var mostrarBusqueda = false
    @State private var textoBusqueda = ""
    @State private var mostrarOpciones = false
    @State private var publicacionConOpciones = 0
    
    // Estados para notificaciones
    @State private var showNotifications = false
    @State private var selectedNotificationTab = 0
    @State private var notificaciones: [Notificacion] = [
        Notificacion(
            tipo: .invitacion,
            usuario: "Carlos",
            actividad: "Juegos de mesa en café central",
            mensaje: "Te ha invitado a una actividad",
            tiempo: "Hace 15 min",
            leida: false,
            imagenURL: nil
        ),
        Notificacion(
            tipo: .recordatorio,
            usuario: nil,
            actividad: "Clase de yoga en el parque",
            mensaje: "Tu actividad comienza en 1 hora",
            tiempo: "Hace 30 min",
            leida: false,
            imagenURL: nil
        ),
        Notificacion(
            tipo: .logro,
            usuario: nil,
            actividad: "5 actividades completadas",
            mensaje: "¡Has ganado el logro 'Socializador'!",
            tiempo: "Hace 2 horas",
            leida: true,
            imagenURL: "medalla"
        ),
        Notificacion(
            tipo: .invitacion,
            usuario: "Ana",
            actividad: "Taller de cerámica",
            mensaje: "Ha aceptado tu invitación",
            tiempo: "Hace 5 horas",
            leida: true,
            imagenURL: nil
        ),
        Notificacion(
            tipo: .sistema,
            usuario: nil,
            actividad: nil,
            mensaje: "Nuevas actividades disponibles cerca de ti",
            tiempo: "Hace 1 día",
            leida: true,
            imagenURL: nil
        )
    ]
    
    let amigos = ["carlos_fit", "ana_yoga", "miguel_runs", "maria_gym", "juan_peso", "laura_fit", "pedro_zen", "sofia_om", "david_peace", "lucia_run"]
    
    let opcionesPublicacion = [
        "Reportar publicación",
        "Dejar de seguir",
        "Copiar enlace",
        "Silenciar"
    ]
    
    let publicaciones = [
        Publicacion(
            usuario: "carlos_fit",
            titulo: "Juegos de mesa en café central",
            descripcion: "Estamos jugando Catan y Ticket to Ride. ¡Únanse si están cerca! 🎲",
            tiempo: "3h",
            volumen: "5 jugadores",
            tieneImagen: true,
            comentarios: [
                Comentario(usuario: "maria_gym", texto: "¡Llego en 10 minutos!"),
                Comentario(usuario: "juan_peso", texto: "Traigan más bebidas")
            ],
            estado: .enCurso,
            horaInicio: Calendar.current.date(byAdding: .hour, value: -1, to: Date()),
            horaFin: Calendar.current.date(byAdding: .hour, value: 3, to: Date())
        ),
        Publicacion(
            usuario: "ana_yoga",
            titulo: "Taller de cerámica",
            descripcion: "Primera vez trabajando con arcilla y me encantó la experiencia. ¡Miren mi primera taza! 🏺",
            tiempo: "2h 30min",
            volumen: "3 piezas",
            tieneImagen: true,
            comentarios: [
                Comentario(usuario: "pedro_zen", texto: "Qué bonito diseño! Vas a esmaltarla?"),
                Comentario(usuario: "sofia_om", texto: "El taller del centro cultural? Yo fui la semana pasada!"),
                Comentario(usuario: "david_peace", texto: "Esa técnica se llama pellizco, verdad?")
            ],
            estado: .concluida,
            horaInicio: nil,
            horaFin: nil
        ),
        Publicacion(
            usuario: "miguel_runs",
            titulo: "Clase de yoga en el parque",
            descripcion: "Sesión de yoga al aire libre en el parque central. Todos son bienvenidos, traigan sus mats! 🧘‍♂️",
            tiempo: "1h 15min",
            volumen: "12 participantes",
            tieneImagen: false,
            comentarios: [],
            estado: .enCurso,
            horaInicio: Calendar.current.date(byAdding: .minute, value: -30, to: Date()),
            horaFin: Calendar.current.date(byAdding: .hour, value: 1, to: Date())
        ),
        Publicacion(
            usuario: "maria_gym",
            titulo: "Sesión de fotos urbana",
            descripcion: "Experimentando con fotografía de larga exposición en el centro histórico. ¡Quedaron geniales los rastros de luz! 📸",
            tiempo: "5h",
            volumen: "126 fotos",
            tieneImagen: true,
            comentarios: [
                Comentario(usuario: "juan_peso", texto: "Qué cámara usaste? Esos efectos son increíbles"),
                Comentario(usuario: "carlos_fit", texto: "La del letrero neón es mi favorita"),
                Comentario(usuario: "laura_fit", texto: "Deberías exponer en la galería del barrio")
            ],
            estado: .concluida,
            horaInicio: nil,
            horaFin: nil
        ),
        Publicacion(
            usuario: "laura_fit",
            titulo: "Jardinería comunitaria",
            descripcion: "Plantando árboles en el jardín comunitario. Necesitamos más voluntarios! 🌳",
            tiempo: "4h",
            volumen: "8 voluntarios",
            tieneImagen: true,
            comentarios: [],
            estado: .enCurso,
            horaInicio: Calendar.current.date(byAdding: .hour, value: -2, to: Date()),
            horaFin: Calendar.current.date(byAdding: .hour, value: 2, to: Date())
        )
    ]
    
    var amigosFiltrados: [String] {
        if textoBusqueda.isEmpty {
            return amigos
        } else {
            return amigos.filter { $0.localizedCaseInsensitiveContains(textoBusqueda) }
        }
    }
    
    private var notificacionesFiltradas: [Notificacion] {
        switch selectedNotificationTab {
        case 1: return notificaciones.filter { $0.tipo == .invitacion }
        case 2: return notificaciones.filter { $0.tipo == .logro }
        default: return notificaciones
        }
    }
    
    private var conteoNotificacionesNoLeidas: Int {
        notificaciones.filter { !$0.leida }.count
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Contenido principal
                ScrollView {
                    VStack(spacing: 20) {
                        // Encabezado
                        HStack {
                            Text("YaQuedamos")
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(Color("BrandPrimary"))
                                .padding(.leading, 16)
                            
                            Spacer()
                            
                            Button(action: {
                                mostrarBusqueda.toggle()
                            }) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primary)
                                    .padding(.trailing, 16)
                            }
                            
                            Button(action: {
                                withAnimation {
                                    showNotifications.toggle()
                                }
                            }) {
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(.primary)
                                    .overlay(
                                        Group {
                                            if conteoNotificacionesNoLeidas > 0 {
                                                Circle()
                                                    .fill(Color.red)
                                                    .frame(width: 10, height: 10)
                                                    .offset(x: 8, y: -8)
                                            }
                                        }
                                    )
                                    .padding(.trailing, 20)
                            }
                        }
                        .padding(.top, 8)
                        
                        // Publicaciones
                        ForEach(Array(publicaciones.enumerated()), id: \.element.id) { index, publicacion in
                            if publicacion.estado == .enCurso {
                                contenidoPublicacionEmergente(indice: index, publicacion: publicacion)
                            } else {
                                contenidoPublicacion(indice: index, publicacion: publicacion)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Overlay de búsqueda
                if mostrarBusqueda {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            mostrarBusqueda = false
                        }
                    
                    VStack {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.leading, 8)
                            
                            TextField("Buscar amigos...", text: $textoBusqueda)
                                .padding(.vertical, 10)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                            
                            Button(action: {
                                textoBusqueda = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .opacity(textoBusqueda.isEmpty ? 0 : 1)
                            }
                            .padding(.trailing, 8)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(10)
                        .padding()
                        
                        List(amigosFiltrados, id: \.self) { amigo in
                            HStack {
                                Circle()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                                    .overlay(
                                        Text(amigo.prefix(1).capitalized)
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                    )
                                
                                Text(amigo)
                                    .font(.system(size: 16))
                                
                                Spacer()
                            }
                            .padding(.vertical, 8)
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .frame(height: 300)
                        
                        Spacer()
                    }
                    .transition(.move(edge: .top))
                    .zIndex(1)
                }
                
                // Menú de opciones
                if mostrarOpciones {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            mostrarOpciones = false
                        }
                    
                    VStack {
                        Spacer()
                        
                        VStack(spacing: 0) {
                            ForEach(opcionesPublicacion, id: \.self) { opcion in
                                Button(action: {
                                    switch opcion {
                                    case "Reportar publicación":
                                        print("Reportar publicación \(publicacionConOpciones)")
                                    case "Dejar de seguir":
                                        print("Dejar de seguir a \(publicaciones[publicacionConOpciones].usuario)")
                                    case "Copiar enlace":
                                        print("Enlace copiado")
                                    case "Silenciar":
                                        print("Usuario silenciado")
                                    default:
                                        break
                                    }
                                    mostrarOpciones = false
                                }) {
                                    HStack {
                                        Text(opcion)
                                            .foregroundColor(opcion == "Reportar publicación" ? .red : .primary)
                                            .padding()
                                        Spacer()
                                    }
                                    .contentShape(Rectangle())
                                }
                                
                                if opcion != opcionesPublicacion.last {
                                    Divider()
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(radius: 5)
                        
                        Button(action: {
                            mostrarOpciones = false
                        }) {
                            Text("Cancelar")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(12)
                                .padding(.horizontal)
                                .padding(.top, 8)
                        }
                        
                        Spacer().frame(height: 50)
                    }
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                }
                
                // Panel de notificaciones
                if showNotifications {
                    Color.black.opacity(0.001)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showNotifications = false
                            }
                        }
                    
                    VStack(alignment: .leading, spacing: 0) {
                        // Encabezado
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Notificaciones")
                                    .font(.system(size: 22, weight: .bold))
                                    .foregroundColor(Color("BrandPrimary"))
                                
                                Spacer()
                                
                                Button(action: {
                                    // Marcar todas como leídas
                                    for i in 0..<notificaciones.count {
                                        notificaciones[i].leida = true
                                    }
                                }) {
                                    Text("Marcar todas")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(Color("BrandPrimary"))
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            // Pestañas personalizadas
                            HStack(spacing: 0) {
                                Button(action: { selectedNotificationTab = 0 }) {
                                    VStack {
                                        Text("Todas")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedNotificationTab == 0 ? Color("BrandPrimary") : .gray)
                                        
                                        if selectedNotificationTab == 0 {
                                            Capsule()
                                                .fill(Color("BrandPrimary"))
                                                .frame(height: 3)
                                                .padding(.horizontal, 10)
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width / 3)
                                
                                Button(action: { selectedNotificationTab = 1 }) {
                                    VStack {
                                        Text("Invitaciones")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedNotificationTab == 1 ? Color("BrandPrimary") : .gray)
                                        
                                        if selectedNotificationTab == 1 {
                                            Capsule()
                                                .fill(Color("BrandPrimary"))
                                                .frame(height: 3)
                                                .padding(.horizontal, 10)
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width / 3)
                                
                                Button(action: { selectedNotificationTab = 2 }) {
                                    VStack {
                                        Text("Logros")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(selectedNotificationTab == 2 ? Color("BrandPrimary") : .gray)
                                        
                                        if selectedNotificationTab == 2 {
                                            Capsule()
                                                .fill(Color("BrandPrimary"))
                                                .frame(height: 3)
                                                .padding(.horizontal, 10)
                                        }
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width / 3)
                            }
                            .padding(.top, 8)
                            
                            Divider()
                        }
                        .background(Color(.systemBackground))
                        
                        // Contenido de notificaciones
                        ScrollView {
                            VStack(spacing: 0) {
                                if notificacionesFiltradas.isEmpty {
                                    VStack {
                                        Image(systemName: "bell.slash.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                            .padding(.top, 50)
                                        
                                        Text("No hay notificaciones")
                                            .font(.system(size: 16, weight: .medium))
                                            .padding(.top, 10)
                                    }
                                    .frame(maxWidth: .infinity)
                                } else {
                                    ForEach(notificacionesFiltradas.indices, id: \.self) { index in
                                        NotificationItem(
                                            notificacion: notificacionesFiltradas[index],
                                            onTap: {
                                                // Marcar como leída al tocar
                                                if let originalIndex = notificaciones.firstIndex(where: { $0.id == notificacionesFiltradas[index].id }) {
                                                    notificaciones[originalIndex].leida = true
                                                }
                                            },
                                            onAcceptInvitation: {
                                                // Lógica para aceptar invitación
                                                print("Invitación aceptada")
                                            },
                                            onDeclineInvitation: {
                                                // Lógica para rechazar invitación
                                                print("Invitación rechazada")
                                            }
                                        )
                                        
                                        if index != notificacionesFiltradas.count - 1 {
                                            Divider()
                                        }
                                    }
                                }
                            }
                        }
                        .background(Color(.systemBackground))
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.7)
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 10)
                    .padding(.top, 50)
                    .padding(.trailing, 10)
                    .transition(.move(edge: .top))
                    .zIndex(2)
                }
            }
            .navigationBarHidden(true)
            .animation(.easeInOut, value: mostrarBusqueda)
            .animation(.easeInOut, value: mostrarOpciones)
            .animation(.easeInOut, value: showNotifications)
            .sheet(isPresented: $mostrarComentarios) {
                VistaComentarios(comentarios: publicaciones[publicacionSeleccionada].comentarios)
            }
        }
    }
    
    // Función auxiliar para calcular el progreso
    private func progressValue(start: Date, end: Date) -> Double {
        let total = end.timeIntervalSince(start)
        let transcurrido = Date().timeIntervalSince(start)
        return min(max(transcurrido / total, 0), 1)
    }
    
    // Nueva función para publicaciones emergentes de actividades en curso
    private func contenidoPublicacionEmergente(indice: Int, publicacion: Publicacion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Badge de "En curso" en la parte superior
            HStack {
                Spacer()
                Text("EN CURSO")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color("BrandPrimary"))
                    .clipShape(Capsule())
                    .offset(y: 8)
                Spacer()
            }
            
            // Contenido principal con borde destacado
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top) {
                    Circle()
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .overlay(
                            Text(publicacion.usuario.prefix(1).capitalized)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(publicacion.usuario)
                            .font(.system(size: 16, weight: .semibold))
                        
                        // Mostrar tiempo transcurrido desde el inicio
                        if let inicio = publicacion.horaInicio {
                            Text("Activa desde \(inicio.timeAgoDisplay())")
                                .font(.system(size: 14))
                                .foregroundColor(Color("BrandPrimary"))
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        publicacionConOpciones = indice
                        mostrarOpciones.toggle()
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 16)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(publicacion.titulo)
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 4)
                    
                    Text(publicacion.descripcion)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .lineSpacing(4)
                    
                    if publicacion.tieneImagen {
                        RoundedRectangle(cornerRadius: 12)
                            .frame(height: 200)
                            .foregroundColor(Color(white: 0.9))
                            .overlay(
                                VStack {
                                    Image(systemName: "photo")
                                        .font(.system(size: 40))
                                        .foregroundColor(.gray)
                                    Text("Imagen de la actividad")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .padding(.top, 8)
                                }
                            )
                            .padding(.top, 8)
                    }
                }
                .padding(.horizontal, 16)
                
                // Barra de progreso para tiempo transcurrido
                if let inicio = publicacion.horaInicio, let fin = publicacion.horaFin {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Progreso de la actividad")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        ProgressView(value: progressValue(start: inicio, end: fin))
                            .progressViewStyle(LinearProgressViewStyle(tint: Color("BrandPrimary")))
                        
                        HStack {
                            Text("Inició: \(inicio.formattedHour())")
                            Spacer()
                            Text("Finaliza: \(fin.formattedHour())")
                        }
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 16)
                }
                
                Divider()
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                
                // Botones de acción especiales para actividades en curso
                HStack(spacing: 16) {
                    Button(action: {
                        // Acción para unirse a la actividad
                    }) {
                        HStack {
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 16))
                            Text("Unirse")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("BrandPrimary"))
                        .cornerRadius(20)
                    }
                    
                    Button(action: {
                        // Acción para ver ubicación
                    }) {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 16))
                            Text("Ubicación")
                                .font(.system(size: 15, weight: .medium))
                        }
                        .foregroundColor(Color("BrandPrimary"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("BrandPrimary").opacity(0.2))
                        .cornerRadius(20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Acción para compartir
                    }) {
                        Image(systemName: "arrowshape.turn.up.right.fill")
                            .font(.system(size: 18))
                            .foregroundColor(Color("BrandPrimary"))
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("BrandPrimary"), lineWidth: 2)
            )
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .shadow(color: Color("BrandPrimary").opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // Función original para publicaciones normales
    private func contenidoPublicacion(indice: Int, publicacion: Publicacion) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .overlay(
                        Text(publicacion.usuario.prefix(1).capitalized)
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(publicacion.usuario)
                        .font(.system(size: 16, weight: .semibold))
                    
                    Text("Quedó hace \(indice + 2) horas")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button(action: {
                    publicacionConOpciones = indice
                    mostrarOpciones.toggle()
                }) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(publicacion.titulo)
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.top, 4)
                
                Text(publicacion.descripcion)
                    .font(.system(size: 16))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                
                if publicacion.tieneImagen {
                    RoundedRectangle(cornerRadius: 12)
                        .frame(height: 200)
                        .foregroundColor(Color(white: 0.9))
                        .overlay(
                            VStack {
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                                Text("Imagen de la actividad")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.top, 8)
                            }
                        )
                        .padding(.top, 8)
                }
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 32) {
                VStack(alignment: .leading) {
                    Text("Tiempo")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(publicacion.tiempo)
                        .font(.system(size: 17, weight: .semibold))
                }
                
                VStack(alignment: .leading) {
                    Text(publicacion.titulo.contains("maratón") ? "Distancia" :
                         publicacion.titulo.contains("WOD") ? "Repeticiones" :
                         publicacion.titulo.contains("Rutina") ? "Volumen" : "Actividad")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                    Text(publicacion.volumen)
                        .font(.system(size: 17, weight: .semibold))
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            Divider()
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                Button(action: {
                    postsLiked[indice].toggle()
                    conteoLikes[indice] += postsLiked[indice] ? 1 : -1
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: postsLiked[indice] ? "heart.fill" : "heart")
                            .foregroundColor(postsLiked[indice] ? .red : .gray)
                            .font(.system(size: 18))
                        Text("\(conteoLikes[indice])")
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                    }
                }
                
                Button(action: {
                    publicacionSeleccionada = indice
                    mostrarComentarios.toggle()
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        Text("\(publicacion.comentarios.count)")
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    postsGuardados[indice].toggle()
                }) {
                    Image(systemName: postsGuardados[indice] ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 18))
                        .foregroundColor(postsGuardados[indice] ? Color("BrandPrimary") : .gray)
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        .padding(.horizontal, 12)
    }
}

// Las estructuras NotificationItem y VistaComentarios permanecen igual que en tu código original

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
            .preferredColorScheme(.light)
    }
}

struct NotificationItem: View {
    let notificacion: Notificacion
    var onTap: (() -> Void)?
    var onAcceptInvitation: (() -> Void)?
    var onDeclineInvitation: (() -> Void)?
    
    var iconoTipo: some View {
        Group {
            switch notificacion.tipo {
            case .recordatorio:
                Image(systemName: "clock.fill")
                    .foregroundColor(.orange)
            case .invitacion:
                Image(systemName: "person.2.fill")
                    .foregroundColor(.green)
            case .logro:
                Image(systemName: "medal.fill")
                    .foregroundColor(.yellow)
            case .sistema:
                Image(systemName: "info.circle.fill")
                    .foregroundColor(.blue)
            }
        }
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let usuario = notificacion.usuario {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                    .overlay(
                        Text(usuario.prefix(1).capitalized)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                    )
            } else if notificacion.imagenURL != nil {
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.yellow)
                    .overlay(
                        iconoTipo
                    )
            } else {
                iconoTipo
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    if let usuario = notificacion.usuario {
                        Text(usuario)
                            .font(.system(size: 15, weight: .semibold))
                    } else if let actividad = notificacion.actividad {
                        Text(actividad)
                            .font(.system(size: 15, weight: .semibold))
                    } else {
                        Text("YaQuedamos")
                            .font(.system(size: 15, weight: .semibold))
                    }
                    
                    Spacer()
                    
                    Text(notificacion.tiempo)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(notificacion.mensaje)
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                
                if let actividad = notificacion.actividad, notificacion.tipo != .logro {
                    Text(actividad)
                        .font(.system(size: 13))
                        .foregroundColor(Color("BrandPrimary"))
                        .padding(.top, 2)
                }
                
                if notificacion.tipo == .invitacion {
                    HStack {
                        Button(action: {
                            onAcceptInvitation?()
                        }) {
                            Text("Aceptar")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            onDeclineInvitation?()
                        }) {
                            Text("Rechazar")
                                .font(.system(size: 14, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding(.top, 6)
                }
            }
            
            if !notificacion.leida {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 8, height: 8)
                    .padding(.top, 4)
            }
        }
        .padding()
        .background(notificacion.leida ? Color(.systemBackground) : Color.blue.opacity(0.05))
        .onTapGesture {
            onTap?()
        }
        .contextMenu {
            Button(action: {
                onTap?()
            }) {
                Label("Marcar como leída", systemImage: "eye.fill")
            }
            
            if notificacion.tipo == .invitacion {
                Button(action: {
                    onAcceptInvitation?()
                }) {
                    Label("Aceptar invitación", systemImage: "checkmark.circle.fill")
                }
                
                Button(action: {
                    onDeclineInvitation?()
                }) {
                    Label("Rechazar invitación", systemImage: "xmark.circle.fill")
                }
            }
        }
        .animation(.easeInOut, value: notificacion.leida)
    }
}

struct VistaComentarios: View {
    let comentarios: [Comentario]
    @State private var nuevoComentario: String = ""
    
    var body: some View {
        VStack {
            Text("Comentarios")
                .font(.title)
                .padding()
            
            List(comentarios, id: \.usuario) { comentario in
                HStack(alignment: .top, spacing: 12) {
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                        .overlay(
                            Text(comentario.usuario.prefix(1).capitalized)
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(comentario.usuario)
                            .font(.system(size: 15, weight: .semibold))
                        
                        Text(comentario.texto)
                            .font(.system(size: 15))
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text("1h")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 8)
            }
            .listStyle(PlainListStyle())
            
            HStack {
                TextField("Añade un comentario...", text: $nuevoComentario)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button(action: {
                    // Lógica para añadir comentario
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color("BrandPrimary"))
                        .padding(.trailing)
                }
            }
            .padding(.bottom)
        }
    }
}
