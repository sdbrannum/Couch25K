//
//  WorkoutTracker.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/9/22.
//

import Foundation
import SwiftUI
import HealthKit
import AVFAudio
import CoreMotion
import WatchKit

class WorkoutTracker : NSObject, ObservableObject, HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    private let healthStore = HKHealthStore()
    private let pedometer = CMPedometer()
    private let exercises: [ExerciseItem]
    private let startDate: Date = Date()
    private let countdownTimer: CountdownTimer
    private let totalWorkoutTime: TimeInterval
    private var workoutBuilder: HKLiveWorkoutBuilder?
    private var workoutSession: HKWorkoutSession?
    
    @Published var workoutTimeLeft: TimeInterval = 0.0
    @Published var exerciseTimeLeft: TimeInterval = 0.0
    @Published var exerciseName: String? = nil
    @Published var active: Bool = false
    @Published var distance: Double = 0.00
    @Published var heartRate: Double = 0.0
        
    var currentExerciseIdx : Int = -1 {
        didSet {
            self.exerciseName = self.currentExercise.exercise.description
            self.exerciseTimeLeft = self.currentExercise.duration
            self.countdownTimer.setExerciseTimeLeft(time: self.exerciseTimeLeft)
        }
    }
    
    var currentExercise : ExerciseItem {
        get {
            return self.exercises[self.currentExerciseIdx]
        }
    }
    
    init(exercises: [ExerciseItem]) {
        
        self.exercises = exercises
        self.totalWorkoutTime = exercises.reduce(0) { acc, curr in acc + curr.duration }
        self.workoutTimeLeft = totalWorkoutTime
        self.countdownTimer = CountdownTimer(workoutTotalTime: self.totalWorkoutTime)
        
        super.init()
        self.startHealthCollection()
        self.setNextExercise()
    }
    
    func start() {
        if self.workoutSession?.state == .paused {
            self.workoutSession?.resume()
        }
        
        self.active = true
        self.countdownTimer.start() { exerciseTimeLeft, workoutTimeLeft in
            self.exerciseTimeLeft = exerciseTimeLeft
            self.workoutTimeLeft = workoutTimeLeft
            if exerciseTimeLeft == 0.0 {
                self.setNextExercise()
            }
        }
    }

    
    func pause() {
        self.active = false
        self.countdownTimer.stop()
        self.workoutSession?.pause()
    }
    
    func cancel() {
        self.pause()
        self.reset()
        self.workoutSession?.end()
        self.workoutBuilder?.discardWorkout()
        self.workoutSession = nil
        self.workoutBuilder = nil
    }

    ///
    /// Finish workout and save to healthstore
    ///
    func finish() {
        self.active = false
        self.countdownTimer.stop()
        self.saveHealthCollection()
        self.workoutSession = nil
        self.workoutBuilder = nil
    }
    
    /**
     TODO: when the view is dismissed and you go to the detail view and then start it again
     the active view still shows the previous session.
     
     if you dismiss to the detail view and then go to the content view and back into a workout
     the initializer runs again.
     
     need to investigate how to dismiss to the content view
     */
    private func reset() {
        self.currentExerciseIdx = 0
        self.workoutTimeLeft = self.totalWorkoutTime
        self.heartRate = 0.0
        self.distance = 0.0
    }

    ///
    /// Activate the next exercise in the workout
    ///
    private func setNextExercise() {
        if self.currentExerciseIdx == (self.exercises.count - 1) {
            WKInterfaceDevice.current().play(.stop)
            self.finish()
        } else {
            WKInterfaceDevice.current().play(.stop)
            WKInterfaceDevice.current().play(.start)
            self.currentExerciseIdx += 1
        }

    }
    
    private func startHealthCollection() {
        let workoutConfig = HKWorkoutConfiguration()
        workoutConfig.activityType = .running
        // TODO: allow setting location type
        workoutConfig.locationType = .indoor
        
        let session : HKWorkoutSession
        do {
            session = try HKWorkoutSession(healthStore: self.healthStore, configuration: workoutConfig)
        } catch {
            // TODO: show error message to user
            return
        }
        
        let builder = session.associatedWorkoutBuilder()
        builder.dataSource = HKLiveWorkoutDataSource(healthStore: self.healthStore, workoutConfiguration: workoutConfig)
        builder.delegate = self
        session.delegate = self
        
        self.workoutBuilder = builder
        self.workoutSession = session
        self.workoutSession!.startActivity(with: self.startDate)
        self.workoutBuilder!.beginCollection(withStart: Date()) { (success, error) in
            
            guard success else {
                // Handle errors.
                return
            }
            
            // Indicate that the session has started.
        }
    }
    
    private func saveHealthCollection() {
        self.workoutSession?.end()
        self.workoutBuilder?.endCollection(withEnd: Date()) { (success, error) in
            
            guard success else {
                // Handle errors.
                return
            }
                                
            self.workoutBuilder?.finishWorkout { (workout, error) in
                
                guard workout != nil else {
                    // Handle errors.
                    return
                }
                
                DispatchQueue.main.async() {
                    // Update the user interface
                }
            }
        }
    }
    

    // TODO: maybe switch out with audio clips using AVFoundation and AVAudioPlayer
    ///
    /// Use Speech Synthesis to say a phrase
    ///
    func annouce(phrase: String) {
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: phrase)

        // Configure the utterance.
        utterance.rate = 0.57
        utterance.pitchMultiplier = 0.8
        utterance.postUtteranceDelay = 0.2
        utterance.volume = 0.8

        // Retrieve the British English voice.
        let voice = AVSpeechSynthesisVoice(language: "en-US")

        // Assign the voice to the utterance.
        utterance.voice = voice
        
        // Create a speech synthesizer.
        let synthesizer = AVSpeechSynthesizer()

        // Tell the synthesizer to speak the utterance.
        synthesizer.speak(utterance)
        
    }
    
    
    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType else {
                return
            }
            switch quantityType {
                case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                    let statistics = workoutBuilder.statistics(for: quantityType)
                    let value = statistics?.sumQuantity()?.doubleValue(for: HKUnit.meterUnit(with: .kilo))
                    print("[workoutBuilder] Distance: \(value!)")
                    DispatchQueue.main.async() {
                        // Update the user interface
                        self.distance = value ?? self.distance
                    }
                case HKQuantityType.quantityType(forIdentifier: .heartRate):
                    let statistics = workoutBuilder.statistics(for: quantityType)
                    let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                    let value = statistics?.mostRecentQuantity()?.doubleValue(for: heartRateUnit)
                    // let stringValue = String(Int(Double(round(1 * value!) / 1)))
                    // bpmLabel.setText(stringValue)
                    print("[workoutBuilder] Heart Rate: \(value!)")
                    DispatchQueue.main.async() {
                        self.heartRate = value ?? self.heartRate
                    }
                default:
                    return
            }
        }
    }
    
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // Retreive the workout event.
        guard let workoutEventType = workoutBuilder.workoutEvents.last?.type else { return }
        print("[workoutBuilderDidCollectEvent] Workout Builder changed event: \(workoutEventType.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("[workoutSession] Changed State: \(toState.rawValue)")
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("[workoutSession] Encountered an error: \(error)")
    }
}
