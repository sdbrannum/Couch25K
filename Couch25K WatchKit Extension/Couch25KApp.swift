//
//  Couch25KApp.swift
//  Couch25K WatchKit Extension
//
//  Created by Steven Brannum on 2/6/22.
//

import SwiftUI

@main
struct Couch25KApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
