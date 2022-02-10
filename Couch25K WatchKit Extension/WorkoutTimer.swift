//
//  WorkoutTimer.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/8/22.
//

import Foundation
import SwiftUI
import HealthKit
import AVFAudio
import CoreMotion


// TODO: rename to workout tracker, extract countdown timer
class WorkoutTimer : ObservableObject {
    private var timer: Timer?
    private var exercises: [ExerciseItem]
    private let healthStore = HKHealthStore()
    private let pedometer = CMPedometer()
    private let totalWorkoutTime: TimeInterval
    private let startDate: Date = Date()
    
    @Published var workoutTimeLeft: TimeInterval = 0.0
    @Published var activityTimeLeft: TimeInterval = 0.0
    @Published var activity: String? = nil
    @Published var active: Bool = false
    
    init(exercises: [ExerciseItem]) {
        self.exercises = exercises
        self.totalWorkoutTime = exercises.reduce(0) { acc, curr in acc + curr.duration }
        self.workoutTimeLeft = totalWorkoutTime
        self.setNextActivity()
    }
    
    func start() {
        // healthStore.start()
        // self.startPedometer()
        guard timer != nil else {
            active = true
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { t in
                self.workoutTimeLeft -= 0.1
                self.activityTimeLeft -= 0.1
                
                if (self.activityTimeLeft < 0.1) {
                    self.setNextActivity()
                }
                
                if (self.workoutTimeLeft < 0.1) {
                    self.activityTimeLeft = 0.0
                    self.workoutTimeLeft = 0.0
                    self.finish()
                    return
                }
            }
            return
        }
    }
    
    func pause() {
        active = false
        timer?.invalidate()
        timer = nil
    }
    
    func cancel() {
        self.pause()
    }

    func finish() {
        active = false
        timer?.invalidate()
        timer = nil
        // healthStore.stop()
        saveToHealthStore()
    }

    
    func setNextActivity() {
        if self.exercises.count > 0 {
            WKInterfaceDevice.current().play(.stop)
            WKInterfaceDevice.current().play(.start)
            let exercise = self.exercises.remove(at: 0)
            self.activity = exercise.exercise.description
            self.activityTimeLeft = exercise.duration
        } else {
            WKInterfaceDevice.current().play(.stop)
            self.finish()
        }
    }
    
    func saveToHealthStore() {
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
    func getPedometerDataForWorkout(startDate: Date, endDate: Date) {
        self.pedometer.queryPedometerData(from: startDate, to: endDate) { data, error in
            print(data as Any)
        }
    }
}
