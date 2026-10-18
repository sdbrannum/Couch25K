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

    func isCompleted(_ workoutName: String) -> Bool {
        completions.contains { $0.workoutName == workoutName }
    }

    func latestCompletion(for workoutName: String) -> WorkoutCompletion? {
        completions
            .filter { $0.workoutName == workoutName }
            .max(by: { $0.date < $1.date })
    }

    func completionCount(for workoutName: String) -> Int {
        completions.filter { $0.workoutName == workoutName }.count
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
