import Foundation
import SwiftUI

enum Exercise: CustomStringConvertible {
    case warmup
    case walk
    case run
    case cooldown

    var description: String {
        switch self {
        case .warmup:   return "Warmup"
        case .walk:     return "Walk"
        case .run:      return "Run"
        case .cooldown: return "Cooldown"
        }
    }

    var color: Color {
        switch self {
        case .warmup:   return .orange
        case .walk:     return .blue
        case .run:      return .green
        case .cooldown: return .orange
        }
    }
}

struct ExerciseItem {
    let exercise: Exercise
    let duration: TimeInterval

    static func run(_ duration: TimeInterval) -> ExerciseItem { ExerciseItem(exercise: .run, duration: duration) }
    static func walk(_ duration: TimeInterval) -> ExerciseItem { ExerciseItem(exercise: .walk, duration: duration) }
}

struct Workout: Identifiable {
    let programID: String
    let name: String
    let exercises: [ExerciseItem]

    var id: String { "\(programID)/\(name)" }

    var totalDuration: TimeInterval {
        exercises.reduce(0) { $0 + $1.duration }
    }
}
