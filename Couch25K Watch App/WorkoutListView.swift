import SwiftUI

struct WorkoutListView: View {
    let program: Program

    var body: some View {
        List {
            ForEach(Array(program.weeks.enumerated()), id: \.offset) { idx, workouts in
                Section {
                    ForEach(workouts) { workout in
                        NavigationLink {
                            WorkoutDetailView(workout: workout)
                        } label: {
                            WorkoutRow(workout: workout)
                        }
                    }
                } header: {
                    WeekHeader(week: idx + 1, workouts: workouts)
                }
            }
        }
        .navigationTitle(program.name)
    }
}

private struct WorkoutRow: View {
    @EnvironmentObject var historyStore: HistoryStore
    let workout: Workout

    var body: some View {
        HStack {
            Text(workout.name)
            Spacer()
            Image(systemName: historyStore.isCompleted(workout)
                  ? "checkmark.circle.fill"
                  : "circle")
                .foregroundStyle(historyStore.isCompleted(workout)
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
                        .fill(historyStore.isCompleted(w) ? Color.green : Color.gray.opacity(0.25))
                        .frame(width: 6, height: 6)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        WorkoutListView(program: .n2r)
            .environmentObject(HistoryStore())
    }
}
