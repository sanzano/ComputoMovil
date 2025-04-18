//
//  ActivityModels.swift
//  YaQuedamos
//
//  Created by Alumno on 04/04/25.
//

import Foundation

enum ActivityCategory: String, CaseIterable, Codable {
    case deportes = "Deportes"
    case juegos = "Juegos"
    case arte = "Arte y Cultura"
    case aprendizaje = "Aprendizaje"
    case social = "Social"
    case voluntariado = "Voluntariado"
}

enum SkillLevel: String, CaseIterable, Codable {
    case principiante = "Principiante"
    case intermedio = "Intermedio"
    case avanzado = "Avanzado"
    case todos = "Todos los niveles"
}

enum ActivityRecurrence: String, CaseIterable, Codable {
    case unica = "Única"
    case diaria = "Diaria"
    case semanal = "Semanal"
    case mensual = "Mensual"
}

struct Activity: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let location: String
    let date: Date
    let category: ActivityCategory
    let currentAttendees: Int
    let maxAttendees: Int
    let isPublic: Bool
    let ageRestriction: Int?
    let genderRestriction: String?
    let recurrence: ActivityRecurrence
    let requirements: [String]
    let skillLevel: SkillLevel
    let organizer: String
    let hasCost: Bool
    let costAmount: Double?
    let chatId: String
    let latitude: Double
    let longitude: Double
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var isUpcoming: Bool {
        date > Date()
    }
}
