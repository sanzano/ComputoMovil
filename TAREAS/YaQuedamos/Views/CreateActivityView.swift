//
//  CreateActivityView.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import SwiftUI
import MapKit

struct CreateActivityView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""
    @State private var location = ""
    @State private var date = Date()
    @State private var selectedCategory: ActivityCategory = .deportes
    @State private var maxAttendees = 10
    @State private var isPublic = true
    @State private var ageRestriction: Int?
    @State private var skillLevel: SkillLevel = .todos
    @State private var recurrence: ActivityRecurrence = .unica
    @State private var requirements: [String] = []
    @State private var newRequirement = ""
    @State private var hasCost = false
    @State private var costAmount: Double?
    @State private var showMap = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 19.4326, longitude: -99.1332),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Header con imagen
                    ZStack(alignment: .bottomLeading) {
                        Rectangle()
                            .fill(Color("BrandPrimary").opacity(0.2))
                            .frame(height: 150)
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 48))
                                    .foregroundColor(Color("BrandPrimary").opacity(0.5))
                            )
                        
                        Text("Nueva Actividad")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color("BrandPrimary"))
                            .padding()
                    }
                    
                    // Formulario
                    VStack(spacing: 16) {
                        // Sección 1: Información básica
                        cardView {
                            VStack(alignment: .leading, spacing: 16) {
                                sectionHeader("Información básica")
                                
                                brandedTextField("Nombre de la actividad", text: $name)
                                brandedTextField("Descripción", text: $description, axis: .vertical)
                                    .lineLimit(3...)
                                
                                HStack {
                                    brandedTextField("Ubicación", text: $location)
                                    Button(action: { showMap = true }) {
                                        Image(systemName: "map")
                                            .foregroundColor(Color("BrandPrimary"))
                                            .padding(8)
                                            .background(Color("BrandPrimary").opacity(0.2))
                                            .clipShape(Circle())
                                    }
                                }
                                
                                DatePicker("Fecha y hora", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .tint(Color("BrandPrimary"))
                                
                                Picker("Categoría", selection: $selectedCategory) {
                                    ForEach(ActivityCategory.allCases, id: \.self) { category in
                                        Text(category.rawValue).tag(category)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color("BrandPrimary"))
                            }
                        }
                        
                        // Sección 2: Configuración
                        cardView {
                            VStack(alignment: .leading, spacing: 16) {
                                sectionHeader("Configuración")
                                
                                Toggle("Actividad pública", isOn: $isPublic)
                                    .tint(Color("BrandPrimary"))
                                
                                Stepper("Máximo participantes: \(maxAttendees)",
                                       value: $maxAttendees, in: 2...50)
                                    .tint(Color("BrandPrimary"))
                                
                                Picker("Nivel de habilidad", selection: $skillLevel) {
                                    ForEach(SkillLevel.allCases, id: \.self) { level in
                                        Text(level.rawValue).tag(level)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color("BrandPrimary"))
                                
                                Picker("Recurrencia", selection: $recurrence) {
                                    ForEach(ActivityRecurrence.allCases, id: \.self) { recur in
                                        Text(recur.rawValue).tag(recur)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color("BrandPrimary"))
                            }
                        }
                        
                        // Sección 3: Requisitos
                        cardView {
                            VStack(alignment: .leading, spacing: 16) {
                                sectionHeader("Requisitos")
                                
                                Picker("Edad mínima", selection: Binding(
                                    get: { ageRestriction ?? 0 },
                                    set: { ageRestriction = $0 == 0 ? nil : $0 }
                                )) {
                                    ForEach(0..<100, id: \.self) { age in
                                        Text(age == 0 ? "Sin restricción" : "\(age)+ años").tag(age)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(Color("BrandPrimary"))
                                
                                // Lista de requisitos
                                if !requirements.isEmpty {
                                    VStack(alignment: .leading) {
                                        ForEach(requirements, id: \.self) { req in
                                            HStack {
                                                Circle()
                                                    .fill(Color("BrandPrimary"))
                                                    .frame(width: 6, height: 6)
                                                Text(req)
                                                Spacer()
                                                Button {
                                                    if let index = requirements.firstIndex(of: req) {
                                                        requirements.remove(at: index)
                                                    }
                                                } label: {
                                                    Image(systemName: "xmark.circle.fill")
                                                        .foregroundColor(.red)
                                                }
                                            }
                                            .padding(.vertical, 4)
                                        }
                                    }
                                }
                                
                                HStack {
                                    TextField("Añadir requisito", text: $newRequirement)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    Button(action: addRequirement) {
                                        Image(systemName: "plus.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(Color("BrandPrimary"))
                                    }
                                    .disabled(newRequirement.isEmpty)
                                }
                            }
                        }
                        
                        // Sección 4: Costo
                        cardView {
                            VStack(alignment: .leading, spacing: 16) {
                                sectionHeader("Costo")
                                
                                Toggle("Tiene costo", isOn: $hasCost)
                                    .tint(Color("BrandPrimary"))
                                
                                if hasCost {
                                    HStack {
                                        Text("Monto:")
                                        TextField("Cantidad", value: $costAmount, format: .currency(code: "MXN"))
                                            .textFieldStyle(.roundedBorder)
                                            .keyboardType(.decimalPad)
                                    }
                                }
                            }
                        }
                        
                        // Botón de creación
                        Button(action: createActivity) {
                            Text("Crear Actividad")
                                .font(.headline.bold())
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("BrandPrimary"))
                                .cornerRadius(12)
                                .shadow(color: Color("BrandPrimary").opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.top, 10)
                    }
                    .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color("BrandPrimary"))
                }
            }
            .sheet(isPresented: $showMap) {
                LocationPickerView(region: $region, locationName: $location)
            }
        }
    }
    
    // MARK: - Componentes personalizados
    
    private func cardView<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            content()
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.headline.bold())
            .foregroundColor(Color("BrandPrimary"))
            .padding(.bottom, 4)
    }
    
    private func brandedTextField(_ placeholder: String, text: Binding<String>, axis: Axis = .horizontal) -> some View {
        TextField(placeholder, text: text, axis: axis)
            .textFieldStyle(.roundedBorder)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color("BrandPrimary").opacity(0.3), lineWidth: 1)
            )
    }
    
    // MARK: - Funciones
    
    private func addRequirement() {
        guard !newRequirement.isEmpty else { return }
        requirements.append(newRequirement)
        newRequirement = ""
    }
    
    private func createActivity() {
        // Validación básica
        guard !name.isEmpty, !location.isEmpty else {
            // Mostrar algún error al usuario
            return
        }
        
        // Aquí iría la lógica para guardar la actividad
        // Por ahora solo cerramos la vista
        dismiss()
    }
}

// Vista para selección de ubicación (mejorada)
struct LocationPickerView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var locationName: String
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Barra de búsqueda
                HStack {
                    TextField("Buscar ubicación", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    Button("Buscar") {
                        // Lógica para buscar ubicación
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("BrandPrimary"))
                    .padding(.trailing)
                }
                .padding(.vertical)
                
                // Mapa
                Map(position: .constant(.region(region)), interactionModes: .all) {
                    Marker(locationName.isEmpty ? "Ubicación seleccionada" : locationName, coordinate: region.center)
                }
                .mapStyle(.standard)
                .edgesIgnoringSafeArea(.top)
                
                // Botón de confirmación
                Button("Confirmar ubicación") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color("BrandPrimary"))
                .padding()
            }
            .navigationTitle("Seleccionar ubicación")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(Color("BrandPrimary"))
                }
            }
        }
    }
}

struct CreateActivityView_Previews: PreviewProvider {
    static var previews: some View {
        CreateActivityView()
    }
}
