import Foundation
import Combine

class HistoryStore: ObservableObject {
    private let storageKey = "workout_completions"

    @Published var completions: [WorkoutCompletion] = [] {
        didSet { persist() }
    }

    init() { load() }

    func record(_ completion: WorkoutCompletion) {
        completions.append(completion)
    }

    func isCompleted(_ workout: Workout) -> Bool {
        completions.contains { $0.matches(workout) }
    }

    func latestCompletion(for workout: Workout) -> WorkoutCompletion? {
        completions
            .filter { $0.matches(workout) }
            .max(by: { $0.date < $1.date })
    }

    func completionCount(for workout: Workout) -> Int {
        completions.filter { $0.matches(workout) }.count
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(completions) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([WorkoutCompletion].self, from: data)
        else { return }
        completions = decoded
    }
}
