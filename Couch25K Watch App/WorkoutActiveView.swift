import SwiftUI
import HealthKit

struct WorkoutActiveView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var historyStore: HistoryStore
    @StateObject private var workoutTracker: WorkoutTracker

    private let workout: Workout

    private let timeFormatter: DateComponentsFormatter = {
        let f = DateComponentsFormatter()
        f.unitsStyle = .positional
        f.allowedUnits = [.minute, .second]
        f.zeroFormattingBehavior = .pad
        return f
    }()

    init(workout: Workout, outdoor: Bool = false) {
        self.workout = workout
        _workoutTracker = StateObject(wrappedValue: WorkoutTracker(
            exercises: workout.exercises,
            locationType: outdoor ? .outdoor : .indoor
        ))
    }

    private var exerciseTimeString: String {
        timeFormatter.string(from: workoutTracker.exerciseTimeLeft) ?? "0:00"
    }

    private var totalTimeString: String {
        timeFormatter.string(from: workoutTracker.workoutTimeLeft) ?? "0:00"
    }

    var body: some View {
        VStack(spacing: 0) {
            statsRow

            Spacer()

            timerBlock

            Spacer()

            controls
        }
        .padding(.horizontal, 6)
        .onAppear { workoutTracker.start() }
        .onChange(of: workoutTracker.isFinished) { _, finished in
            guard finished else { return }
            historyStore.record(WorkoutCompletion(
                id: UUID(),
                programID: workout.programID,
                workoutName: workout.name,
                date: Date(),
                distanceKm: workoutTracker.distance
            ))
            dismiss()
        }
    }

    private var statsRow: some View {
        HStack {
            Label("\(Int(workoutTracker.heartRate))", systemImage: "heart.fill")
                .foregroundStyle(.red)
            Spacer()
            Text(String(format: "%.2f km", workoutTracker.distance))
                .foregroundStyle(.secondary)
        }
        .font(.caption.monospacedDigit())
    }

    private var timerBlock: some View {
        VStack(spacing: 6) {
            if let type = workoutTracker.exerciseType {
                Text(type.description.uppercased())
                    .font(.caption2.weight(.semibold))
                    .tracking(1.5)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 3)
                    .background(type.color.opacity(0.2), in: Capsule())
                    .foregroundStyle(type.color)
            }

            Text(exerciseTimeString)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(workoutTracker.exerciseType?.color ?? .primary)

            Text(totalTimeString + " left")
                .font(.caption2)
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
    }

    private var controls: some View {
        HStack {
            Button {
                workoutTracker.cancel()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.red)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)

            Spacer()

            if workoutTracker.active {
                Button { workoutTracker.pause() } label: {
                    Image(systemName: "pause.fill")
                        .font(.title3)
                        .foregroundStyle(.primary)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            } else {
                Button { workoutTracker.start() } label: {
                    Image(systemName: "play.fill")
                        .font(.title3)
                        .foregroundStyle(.green)
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Button { workoutTracker.skip() } label: {
                Image(systemName: "forward.end.fill")
                    .font(.title3)
                    .foregroundStyle(.primary)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    WorkoutActiveView(workout: Program.c25k.workouts[0])
        .environmentObject(HistoryStore())
}
