//
//  WorkoutActive.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import SwiftUI



struct WorkoutActiveView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var workoutTimer: WorkoutTimer
    var exercises: [ExerciseItem]    
    
    let dateFormatter = DateComponentsFormatter()
    
    
    init(exercises: [ExerciseItem]) {
        self.exercises = exercises
        self.workoutTimer = WorkoutTimer(exercises: exercises)
    }
    
    
    var totalTimeRemainingString : String {
        return dateFormatter.string(from: self.workoutTimer.workoutTimeLeft)!
    }
    
    var currentActivityTimeString : String {
        get {
            if let activity = self.workoutTimer.activity {
                return "\(activity): \(dateFormatter.string(from: self.workoutTimer.activityTimeLeft)!)"
            }
            return ""
        }
    }
    
    var body: some View {
        VStack {
            Text(totalTimeRemainingString)
                .font(Font.subheadline)
            
            Text(currentActivityTimeString)
                .font(Font.title)
                .padding(.bottom, 10)

            
            HStack {
               Button(action: {
                   self.workoutTimer.cancel()
                   dismiss()
                   
                }) {
                    Image(systemName: "xmark")
                      .foregroundColor(.red)
                    // Text("Cancel")
                }
           
                
                if workoutTimer.active {
                    Button(action: { self.workoutTimer.pause() }) {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.gray)
                        // Text("Pause")
                    }
                } else {
                    Button(action: { self.workoutTimer.start() }) {
                        Image(systemName: "play")
                            .foregroundColor(.green)
                        // Text("Resume")
                    }
                }
            }
            .onAppear {
                self.workoutTimer.start()
                self.startPedometer()
            }
            //.onDisappear { self.workoutTimer.stop() }
        }

    }
    
    

    
}

struct WorkoutActive_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutActiveView(exercises: workouts[0].exercises)
    }
}
