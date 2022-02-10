//
//  CoundownTimer.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/9/22.
//

import Foundation

class CountdownTimer {
    private var timer: Timer?
    private var exerciseTimeLeft: TimeInterval = 0.0
    private var workoutTimeLeft: TimeInterval = 0.0
    private let withTimeInterval: TimeInterval = 0.1
    
    init(workoutTotalTime: TimeInterval) {
        self.workoutTimeLeft = workoutTotalTime
    }
    
    func setExerciseTimeLeft(time: TimeInterval) {
        self.exerciseTimeLeft = time
    }
    
    func start(onTimeLeftUpdate: @escaping (_ exerciseTimeLeft: TimeInterval, _ workoutTimeLeft: TimeInterval) -> ()) {
        if self.exerciseTimeLeft < 0.0 {
            return
        }
        guard timer != nil else {
            self.timer = Timer.scheduledTimer(withTimeInterval: self.withTimeInterval, repeats: true) { t in
                self.exerciseTimeLeft = self.getTimeStepped(time: self.exerciseTimeLeft, timeInterval: -0.1)
                self.workoutTimeLeft = self.getTimeStepped(time: self.workoutTimeLeft, timeInterval: -0.1)
                onTimeLeftUpdate(self.exerciseTimeLeft, self.workoutTimeLeft)
                
                if (self.exerciseTimeLeft == 0.0) {
                    self.stop()
                    return
                }
            }
            return
        }
    }
    
    ///
    /// Get TimeInterval with single significant digit
    ///
    private func getTimeStepped(time: TimeInterval, timeInterval: TimeInterval) -> Double {
        return Double(round(10 * (time + timeInterval)) / 10)
    }
    
    func stop() {
        self.timer?.invalidate()
        self.timer = nil
    }
}
