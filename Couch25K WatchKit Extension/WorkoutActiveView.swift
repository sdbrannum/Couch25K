//
//  WorkoutActive.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import SwiftUI



struct WorkoutActiveView: View {
    @Environment(\.dismiss) var dismiss
    // @ObservedObject var workoutTimer: WorkoutTimer
    @ObservedObject var workoutTracker: WorkoutTracker
    var exercises: [ExerciseItem]    
    
    let dateFormatter = DateComponentsFormatter()
    
    
    init(exercises: [ExerciseItem]) {
        print("init workout active view")
        self.exercises = exercises
        // self.workoutTimer = WorkoutTimer(exercises: exercises)
        self.workoutTracker = WorkoutTracker(exercises: exercises)
    }
    
    
    var totalTimeRemainingString : String {
        return dateFormatter.string(from: self.workoutTracker.workoutTimeLeft)!
    }
    
    var currentActivityTimeString : String {
        get {
            if let exerciseName = self.workoutTracker.exerciseName {
                return "\(exerciseName): \(dateFormatter.string(from: self.workoutTracker.exerciseTimeLeft)!)"
            }
            return ""
        }
    }
    
    var heartRate : Int {
        return Int(self.workoutTracker.heartRate)
    }
    
    var distance: String {
        return String(Double(round(100 * (self.workoutTracker.distance)) / 100))
    }
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                Text("\(heartRate)")
                    .foregroundColor(.red)
                    
                Spacer()
                Text("\(distance) km")
            }
            Spacer()
            Text(totalTimeRemainingString)
                .font(Font.subheadline)
            
            Text(currentActivityTimeString)
                .font(Font.title)
                .padding(.bottom, 10)
                .foregroundColor(.yellow)
            
            Spacer()
            
            HStack {
               Button(action: {
                   self.workoutTracker.cancel()
                   dismiss()
                   
                }) {
                    Image(systemName: "xmark")
                      .foregroundColor(.red)
                    // Text("Cancel")
                }
           
                
                if workoutTracker.active {
                    Button(action: { self.workoutTracker.pause() }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.gray)
                        // Text("Pause")
                    }
                } else {
                    Button(action: { self.workoutTracker.start() }) {
                        Image(systemName: "play")
                            .foregroundColor(.green)
                        // Text("Resume")
                    }
                }
            }
            .onAppear {
                self.workoutTracker.start()
                // self.startPedometer()
            }
            .onDisappear { self.workoutTracker.cancel() }
        }

    }    
}

struct WorkoutActive_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutActiveView(exercises: workouts[0].exercises)
    }
}
