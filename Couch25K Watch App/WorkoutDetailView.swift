import SwiftUI

struct WorkoutDetailView: View {
    @EnvironmentObject var historyStore: HistoryStore
    let workout: Workout

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if !workout.exercises.isEmpty {
                    infoRow
                    IntervalStrip(exercises: workout.exercises)
                }

                if let last = historyStore.latestCompletion(for: workout) {
                    completionSummary(last)
                }

                startButton
            }
            .padding(.horizontal, 4)
            .padding(.top, 8)
        }
        .navigationTitle(workout.name)
    }

    private var infoRow: some View {
        let minutes = Int(workout.totalDuration / 60)
        let runCount = workout.exercises.filter { $0.exercise == .run }.count
        return HStack {
            Text("\(minutes) min")
            Spacer()
            Text(runCount == 1 ? "1 interval" : "\(runCount) intervals")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    @ViewBuilder
    private func completionSummary(_ last: WorkoutCompletion) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            let count = historyStore.completionCount(for: workout)
            Label(
                count == 1 ? "Completed once" : "Completed \(count)×",
                systemImage: "checkmark.circle.fill"
            )
            .foregroundStyle(.green)
            .font(.caption.weight(.semibold))

            Label(last.date.formatted(.dateTime.month(.abbreviated).day().year()),
                  systemImage: "calendar")
                .font(.caption)
                .foregroundStyle(.secondary)

            Label(String(format: "%.2f km", last.distanceKm),
                  systemImage: "figure.run")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.green.opacity(0.1), in: RoundedRectangle(cornerRadius: 10))
    }

    @ViewBuilder
    private var startButton: some View {
        if workout.exercises.isEmpty {
            Text("Coming soon")
                .font(.caption)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 4)
        } else {
            NavigationLink {
                WorkoutActiveView(workout: workout)
                    .navigationBarBackButtonHidden(true)
            } label: {
                Label(
                    historyStore.isCompleted(workout) ? "Start Again" : "Start",
                    systemImage: "play.fill"
                )
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .frame(maxWidth: .infinity)
        }
    }
}

private struct IntervalStrip: View {
    let exercises: [ExerciseItem]

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 1) {
                ForEach(exercises.indices, id: \.self) { i in
                    let ex = exercises[i]
                    let total = exercises.reduce(0.0) { $0 + $1.duration }
                    let width = max(2, proxy.size.width * CGFloat(ex.duration / total))
                    RoundedRectangle(cornerRadius: 2)
                        .fill(ex.exercise.color)
                        .frame(width: width)
                }
            }
        }
        .frame(height: 8)
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(workout: Program.c25k.workouts[0])
            .environmentObject(HistoryStore())
    }
}
