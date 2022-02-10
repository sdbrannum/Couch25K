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

class WorkoutTracker : ObservableObject {
    private let healthStore = HKHealthStore()
    private let pedometer = CMPedometer()
    private let exercises: [ExerciseItem]
    private let startDate: Date = Date()
    private let countdownTimer: CountdownTimer
    private let totalWorkoutTime: TimeInterval
    
    @Published var workoutTimeLeft: TimeInterval = 0.0
    @Published var exerciseTimeLeft: TimeInterval = 0.0
    @Published var exerciseName: String? = nil
    @Published var active: Bool = false
        
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
        self.setNextExercise()
    }
    
    func start() {
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
    }
    
    func cancel() {
        self.pause()
        self.reset()
    }

    ///
    /// Finish workout and save to healthstore
    ///
    func finish() {
        self.active = false
        self.countdownTimer.stop()
        // healthStore.stop()
        self.saveToHealthStore()
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
//
//
//        if self.exercises.count > 0 {
//            WKInterfaceDevice.current().play(.stop)
//            WKInterfaceDevice.current().play(.start)
//            let exercise = self.exercises.remove(at: 0)
//            let x = self.exercises.
//            self.exerciseName = exercise.exercise.description
//            self.exerciseTimeLeft = exercise.duration
//            self.countdownTimer.setExerciseTimeLeft(time: self.exerciseTimeLeft)
//        } else {
//            WKInterfaceDevice.current().play(.stop)
//            self.finish()
//        }
    }
    
    ///
    /// Save workout data to HealthStore
    ///
    private func saveToHealthStore() {
        let endDate = Date()
        getPedometerDataForWorkout(startDate: self.startDate, endDate: endDate)
        return
//        let workoutConfig = HKWorkoutConfiguration()
//        workoutConfig.activityType = .running
//        let builder = HKWorkoutBuilder(
//            healthStore: self.healthStore,
//            configuration: workoutConfig,
//            device: .local()
//        )
//
//        builder.beginCollection(withStart: Date()) { success, error in
//            guard success else {
//                return
//            }
//            guard let quantityType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
//                return
//            }
//            let quantity = HKQuantity(unit: .meter(), doubleValue: 11.1)
//            let sample = HKCumulativeQuantitySample(
//                type: quantityType,
//                quantity: quantity,
//                start: self.startDate,
//                end: endDate
//            )
//
//            //1. Add the sample to the workout builder
//            builder.add([sample]) { (success, error) in
//              guard success else {
//                return
//              }
//
//              //2. Finish collection workout data and set the workout end date
//              builder.endCollection(withEnd: endDate) { (success, error) in
//                guard success else {
//                  return
//                }
//
//                //3. Create the workout with the samples added
//                builder.finishWorkout { (_, error) in
//                  return
//                }
//              }
//            }
//        }
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
//
//    func startPedometer() {
//        if CMPedometer.isStepCountingAvailable() {
//            self.pedometer.startUpdates(from: Date()) { data, error in
//                print(data as Any)
//            }
//        }
//    }
//
//    func stopPedometer() {
//        self.pedometer.stopUpdates()
//    }
//
    
    ///
    /// Get pedometer data for the workout
    ///
    func getPedometerDataForWorkout(startDate: Date, endDate: Date) {
        self.pedometer.queryPedometerData(from: startDate, to: endDate) { data, error in
            print(data as Any)
        }
    }
}
