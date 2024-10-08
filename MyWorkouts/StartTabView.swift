//
//  StartTabView.swift
//  MyWorkouts
//
//  Created by EdwardElric on 2024/10/8.
//

import SwiftData
import SwiftUI

struct StartTabView: View {
    var body: some View {
        TabView {
            ActivityListView()
                .tabItem {
                    Label("Activities", systemImage: "figure.mixed.cardio")
                }
            CalendarHeaderView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    StartTabView()
        .modelContainer(Activity.preview)
}
