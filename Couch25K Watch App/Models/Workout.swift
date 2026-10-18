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
}

struct Workout: Identifiable {
    let id = UUID()
    let name: String
    let exercises: [ExerciseItem]

    var totalDuration: TimeInterval {
        exercises.reduce(0) { $0 + $1.duration }
    }
}

var workouts = [
    Workout(name: "Day 1",
        exercises: [
            ExerciseItem(exercise: .warmup,   duration: 300),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .cooldown, duration: 300),
        ]
    ),
    Workout(name: "Day 2",
        exercises: [
            ExerciseItem(exercise: .warmup,   duration: 300),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .cooldown, duration: 300),
        ]
    ),
    Workout(name: "Day 3",
        exercises: [
            ExerciseItem(exercise: .warmup,   duration: 300),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .walk,     duration: 90),
            ExerciseItem(exercise: .run,      duration: 60),
            ExerciseItem(exercise: .cooldown, duration: 300),
        ]
    ),
    Workout(name: "Day 4",
        exercises: [
            ExerciseItem(exercise: .warmup,   duration: 5),
            ExerciseItem(exercise: .run,      duration: 5),
            ExerciseItem(exercise: .walk,     duration: 5),
            ExerciseItem(exercise: .run,      duration: 5),
            ExerciseItem(exercise: .walk,     duration: 5),
            ExerciseItem(exercise: .cooldown, duration: 5),
        ]
    ),
    Workout(name: "Day 5",  exercises: []),
    Workout(name: "Day 6",  exercises: []),
    Workout(name: "Day 7",  exercises: []),
    Workout(name: "Day 8",  exercises: []),
    Workout(name: "Day 9",  exercises: []),
    Workout(name: "Day 10", exercises: []),
    Workout(name: "Day 11", exercises: []),
    Workout(name: "Day 12", exercises: []),
    Workout(name: "Day 13", exercises: []),
    Workout(name: "Day 14", exercises: []),
    Workout(name: "Day 15", exercises: []),
    Workout(name: "Day 16", exercises: []),
    Workout(name: "Day 17", exercises: []),
    Workout(name: "Day 18", exercises: []),
    Workout(name: "Day 19", exercises: []),
    Workout(name: "Day 20", exercises: []),
    Workout(name: "Day 21", exercises: []),
    Workout(name: "Day 22", exercises: []),
    Workout(name: "Day 23", exercises: []),
    Workout(name: "Day 24", exercises: []),
    Workout(name: "Day 25", exercises: []),
    Workout(name: "Day 26", exercises: []),
    Workout(name: "Day 27", exercises: []),
    Workout(name: "Day 28", exercises: []),
    Workout(name: "Day 29", exercises: []),
    Workout(name: "Day 30", exercises: []),
]
