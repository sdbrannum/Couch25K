import Foundation

struct Program: Identifiable {
    let id: String
    let name: String
    let weeks: [[Workout]]

    var workouts: [Workout] { weeks.flatMap { $0 } }

    /// Each session is the run/walk intervals only; a 5 minute warmup and cooldown
    /// are added around it, and a trailing walk is dropped since the cooldown replaces it.
    init(id: String, name: String, weeks: [[[ExerciseItem]]]) {
        self.id = id
        self.name = name
        var day = 0
        self.weeks = weeks.map { sessions in
            sessions.map { intervals in
                day += 1
                var items = intervals
                if items.last?.exercise == .walk { items.removeLast() }
                return Workout(
                    programID: id,
                    name: "Day \(day)",
                    exercises: [ExerciseItem(exercise: .warmup, duration: 300)]
                        + items
                        + [ExerciseItem(exercise: .cooldown, duration: 300)]
                )
            }
        }
    }
}

private func repeated(_ count: Int, _ pattern: ExerciseItem...) -> [ExerciseItem] {
    Array(Array(repeating: pattern, count: count).joined())
}

private func sameAllWeek(_ intervals: [ExerciseItem]) -> [[ExerciseItem]] {
    Array(repeating: intervals, count: 3)
}

extension Program {
    static let all = [c25k, n2r]

    static let c25k = Program(id: "c25k", name: "C25K", weeks: [
        sameAllWeek(repeated(8, .run(60), .walk(90))),
        sameAllWeek(repeated(6, .run(90), .walk(120))),
        sameAllWeek(repeated(2, .run(90), .walk(90), .run(180), .walk(180))),
        sameAllWeek([.run(180), .walk(90), .run(300), .walk(150), .run(180), .walk(90), .run(300)]),
        [
            [.run(300), .walk(180), .run(300), .walk(180), .run(300)],
            [.run(480), .walk(300), .run(480)],
            [.run(1200)],
        ],
        [
            [.run(300), .walk(180), .run(480), .walk(180), .run(300)],
            [.run(600), .walk(180), .run(600)],
            [.run(1500)],
        ],
        sameAllWeek([.run(1500)]),
        sameAllWeek([.run(1680)]),
        sameAllWeek([.run(1800)]),
    ])

    static let n2r = Program(id: "n2r", name: "N2R", weeks: [
        sameAllWeek(repeated(8, .run(30), .walk(120))),
        sameAllWeek(repeated(7, .run(60), .walk(120))),
        sameAllWeek(repeated(9, .run(60), .walk(120))),
        sameAllWeek(repeated(7, .run(90), .walk(120))),
        sameAllWeek(repeated(10, .run(90), .walk(60))),
        sameAllWeek(repeated(10, .run(90), .walk(60))),
        sameAllWeek(repeated(10, .run(120), .walk(30))),
        sameAllWeek(repeated(10, .run(120), .walk(30))),
        sameAllWeek(repeated(4, .run(300), .walk(120))),
        sameAllWeek([.run(1200)]),
        sameAllWeek([.run(1320)]),
        sameAllWeek([.run(1500)]),
    ])
}
