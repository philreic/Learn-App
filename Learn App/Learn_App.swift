//
//  Learn_AppApp.swift
//  Learn App
//
//  Created by Philippe Reichen on 10/17/21.
//

import SwiftUI

@main
struct Learn_App: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
