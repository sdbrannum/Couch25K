//
//  Couch25KApp.swift
//  Couch25K Watch App
//
//  Created by Steven Brannum on 10/18/26.
//

import SwiftUI

@main
struct Couch25KApp: App {
    @StateObject private var historyStore = HistoryStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyStore)
        }
    }
}
