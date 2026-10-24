import Foundation
import Combine
import SwiftUI
import HealthKit
import WatchKit

class WorkoutTracker: NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    private let healthStore = HKHealthStore()
    private let exercises: [ExerciseItem]
    private let countdownTimer: CountdownTimer
    private let totalWorkoutTime: TimeInterval
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var workoutSession: HKWorkoutSession?
    private var startDate: Date?

    @Published var workoutTimeLeft: TimeInterval = 0.0
    @Published var exerciseTimeLeft: TimeInterval = 0.0
    @Published var exerciseName: String? = nil
    @Published var exerciseType: Exercise? = nil
    @Published var active: Bool = false
    @Published var isFinished: Bool = false
    @Published var distance: Double = 0.0
    @Published var heartRate: Double = 0.0

    private(set) var currentExerciseIdx: Int = -1 {
        didSet {
            guard currentExerciseIdx < exercises.count else { return }
            exerciseName = currentExercise.exercise.description
            exerciseType = currentExercise.exercise
            exerciseTimeLeft = currentExercise.duration
            countdownTimer.setExerciseTimeLeft(time: exerciseTimeLeft)
        }
    }

    private var currentExercise: ExerciseItem {
        exercises[currentExerciseIdx]
    }

    init(exercises: [ExerciseItem]) {
        self.exercises = exercises
        totalWorkoutTime = exercises.reduce(0) { $0 + $1.duration }
        workoutTimeLeft = totalWorkoutTime
        countdownTimer = CountdownTimer(workoutTotalTime: totalWorkoutTime)
        super.init()
        guard !exercises.isEmpty else { return }
        setNextExercise()
    }

    func start() {
        guard !exercises.isEmpty else { return }

        if startDate == nil {
            startDate = Date()
            startHealthCollection()
        } else if workoutSession?.state == .paused {
            workoutSession?.resume()
        }

        active = true
        countdownTimer.start { [weak self] exerciseTimeLeft, workoutTimeLeft in
            guard let self else { return }
            self.exerciseTimeLeft = exerciseTimeLeft
            self.workoutTimeLeft = workoutTimeLeft
            if exerciseTimeLeft == 0.0 {
                self.setNextExercise()
            }
        }
    }

    func pause() {
        active = false
        countdownTimer.stop()
        if workoutSession?.state == .running {
            workoutSession?.pause()
        }
    }

    func cancel() {
        guard !isFinished else { return }
        pause()
        workoutSession?.end()
        workoutBuilder?.discardWorkout()
        workoutSession = nil
        workoutBuilder = nil
    }

    func skip() {
        guard !isFinished, currentExerciseIdx >= 0 else { return }
        workoutTimeLeft = countdownTimer.skipExercise()
        setNextExercise()
    }

    func finish() {
        active = false
        countdownTimer.stop()
        saveHealthCollection()
        isFinished = true
        workoutSession = nil
        workoutBuilder = nil
    }

    private func setNextExercise() {
        WKInterfaceDevice.current().play(.stop)
        if currentExerciseIdx == exercises.count - 1 {
            finish()
        } else {
            WKInterfaceDevice.current().play(.start)
            currentExerciseIdx += 1
        }
    }

    private func startHealthCollection() {
        guard let startDate else { return }

        let config = HKWorkoutConfiguration()
        config.activityType = .running
        config.locationType = .indoor

        let session: HKWorkoutSession
        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: config)
        } catch {
            return
        }

        let builder = session.associatedWorkoutBuilder()
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: config)
        builder.delegate = self
        session.delegate = self

        workoutBuilder = builder
        workoutSession = session
        workoutSession?.startActivity(with: startDate)
        workoutBuilder?.beginCollection(withStart: startDate) { _, _ in }
    }

    private func saveHealthCollection() {
        workoutSession?.end()
        workoutBuilder?.endCollection(withEnd: Date()) { [weak self] success, _ in
            guard success, let self else { return }
            self.workoutBuilder?.finishWorkout { _, _ in }
        }
    }

    // MARK: - HKLiveWorkoutBuilderDelegate

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else { continue }
            switch quantityType {
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                let value = workoutBuilder.statistics(for: quantityType)?
                    .sumQuantity()?.doubleValue(for: .meterUnit(with: .kilo))
                DispatchQueue.main.async { self.distance = value ?? self.distance }
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let unit = HKUnit.count().unitDivided(by: .minute())
                let value = workoutBuilder.statistics(for: quantityType)?
                    .mostRecentQuantity()?.doubleValue(for: unit)
                DispatchQueue.main.async { self.heartRate = value ?? self.heartRate }
            default:
                break
            }
        }
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}

    // MARK: - HKWorkoutSessionDelegate

    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {}

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {}
}
