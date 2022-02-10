//
//  WorkoutDays.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import Foundation

enum Exercise : CustomStringConvertible {
    case warmup
    case walk
    case run
    case cooldown
    
    var description: String {
        switch self {
            case .warmup:
                return "Warm"
            case .walk:
                return "Walk"
            case .run:
                return "Run"
            case .cooldown:
                return "Cool"
        }
    }
}

struct ExerciseItem {
    let exercise: Exercise
    let duration: TimeInterval
}

struct Workout : Identifiable {
    let id = UUID()
    let name: String
    let exercises: [ExerciseItem]
}

var workouts = [
    Workout(name: "Day 1",
        exercises: [
            ExerciseItem(exercise: Exercise.warmup, duration: 5),
            ExerciseItem(exercise: Exercise.run, duration: 10),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.cooldown, duration: 300),
        ]
       ),
    Workout(name: "Day 2",
        exercises: [
            ExerciseItem(exercise: Exercise.warmup, duration: 300),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.cooldown, duration: 300),
        ]
   ),
    Workout(name: "Day 3",
        exercises: [
            ExerciseItem(exercise: Exercise.warmup, duration: 300),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.walk, duration: 90),
            ExerciseItem(exercise: Exercise.run, duration: 60),
            ExerciseItem(exercise: Exercise.cooldown, duration: 300),
        ]
       ),
    Workout(name: "Day 4", exercises: []),
    Workout(name: "Day 5", exercises: []),
    
    Workout(name: "Day 6", exercises: []),
    Workout(name: "Day 7", exercises: []),
    Workout(name: "Day 8", exercises: []),
    Workout(name: "Day 9", exercises: []),
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
