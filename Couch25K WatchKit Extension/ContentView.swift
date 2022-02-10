//
//  ContentView.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import SwiftUI
import HealthKit

func requestHealthStoreAccess() {
    let healthStore = HKHealthStore()
    // The quantity type to write to the health store.
    let typesToShare: Set = [
        HKQuantityType.workoutType()
    ]

    // The quantity types to read from the health store.
    let typesToRead: Set = [
        HKQuantityType.quantityType(forIdentifier: .heartRate)!,
        HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
        HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!
    ]

    // Request authorization for those quantity types.
    healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (success, error) in
        // Handle errors here.
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(workouts) { workout in
                NavigationLink {
                    WorkoutDetailView(workout: workout)
                }  label: {
                    Text(workout.name)
                }
            }
            .navigationTitle("Workouts")
        }
        .onAppear() {
            requestHealthStoreAccess()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
