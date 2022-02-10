//
//  WorkoutDetail.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import SwiftUI

struct WorkoutDetailView: View {
    private var duration: String!
    var workout: Workout
    
    init(workout: Workout) {
        self.workout = workout;
        self.duration = getDurationString()
    }
    
    var body: some View {
        Text(workout.name)
            .font(Font.title)
    
        Text(duration)
            .font(Font.subheadline)
            .padding(.bottom, 10)
        
        NavigationLink() {
            WorkoutActiveView(exercises: workout.exercises)
                .navigationBarBackButtonHidden(true)
        } label :  {
            Image(systemName: "play")
                        .foregroundColor(.green)
            Text("Start")
        }
        .buttonStyle(.bordered)
    }
    
    func getDurationString() -> String {
        var totalTime: TimeInterval = workout.exercises.reduce(0) { acc, curr in acc + curr.duration }
        
        totalTime = totalTime / 60
        return "\(totalTime) min"
    }
}

struct WorkoutDetail_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView(workout: workouts[0])
    }
}
