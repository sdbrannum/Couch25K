import Foundation

struct WorkoutCompletion: Codable, Identifiable {
    let id: UUID
    let programID: String
    let workoutName: String
    let date: Date
    let distanceKm: Double

    func matches(_ workout: Workout) -> Bool {
        programID == workout.programID && workoutName == workout.name
    }
}

extension WorkoutCompletion {
    // Completions saved before programs existed have no programID; they were all C25K.
    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        programID = try c.decodeIfPresent(String.self, forKey: .programID) ?? Program.c25k.id
        workoutName = try c.decode(String.self, forKey: .workoutName)
        date = try c.decode(Date.self, forKey: .date)
        distanceKm = try c.decode(Double.self, forKey: .distanceKm)
    }
}
