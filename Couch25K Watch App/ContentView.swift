import SwiftUI
import HealthKit

struct ContentView: View {
    private let healthStore = HKHealthStore()

    var body: some View {
        NavigationStack {
            List(Program.all) { program in
                NavigationLink {
                    WorkoutListView(program: program)
                } label: {
                    ProgramRow(program: program)
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

private struct ProgramRow: View {
    @EnvironmentObject var historyStore: HistoryStore
    let program: Program

    var body: some View {
        let workouts = program.workouts
        let completed = workouts.filter { historyStore.isCompleted($0) }.count
        VStack(alignment: .leading, spacing: 4) {
            Text(program.name)
                .font(.headline)
            Text("\(program.weeks.count) weeks · \(completed)/\(workouts.count) done")
                .font(.caption)
                .foregroundStyle(.secondary)
            ProgressView(value: Double(completed), total: Double(workouts.count))
                .tint(.green)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ContentView()
        .environmentObject(HistoryStore())
}
