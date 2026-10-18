import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var historyStore: HistoryStore
    private let healthStore = HKHealthStore()

    private var weekGroups: [(week: Int, workouts: [Workout])] {
        stride(from: 0, to: workouts.count, by: 3).enumerated().map { idx, start in
            (idx + 1, Array(workouts[start..<min(start + 3, workouts.count)]))
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(weekGroups, id: \.week) { group in
                    Section {
                        ForEach(group.workouts) { workout in
                            NavigationLink {
                                WorkoutDetailView(workout: workout)
                            } label: {
                                WorkoutRow(workout: workout)
                            }
                        }
                    } header: {
                        WeekHeader(week: group.week, workouts: group.workouts)
                    }
                }
            }
            .navigationTitle("Couch25K")
        }
        .onAppear { requestHealthAccess() }
    }

    private func requestHealthAccess() {
        let typesToShare: Set = [HKQuantityType.workoutType()]
        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
        ]
        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { _, _ in }
    }
}

private struct WorkoutRow: View {
    @EnvironmentObject var historyStore: HistoryStore
    let workout: Workout

    var body: some View {
        HStack {
            Text(workout.name)
            Spacer()
            Image(systemName: historyStore.isCompleted(workout.name)
                  ? "checkmark.circle.fill"
                  : "circle")
                .foregroundStyle(historyStore.isCompleted(workout.name)
                  ? Color.green
                  : Color.gray.opacity(0.4))
        }
    }
}

private struct WeekHeader: View {
    @EnvironmentObject var historyStore: HistoryStore
    let week: Int
    let workouts: [Workout]

    var body: some View {
        HStack(spacing: 6) {
            Text("Week \(week)")
            Spacer()
            HStack(spacing: 4) {
                ForEach(workouts) { w in
                    Circle()
                        .fill(historyStore.isCompleted(w.name) ? Color.green : Color.gray.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryStore())
}
