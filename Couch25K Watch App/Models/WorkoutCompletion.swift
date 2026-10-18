import Foundation

struct WorkoutCompletion: Codable, Identifiable {
    let id: UUID
    let workoutName: String
    let date: Date
    let distanceKm: Double
}
