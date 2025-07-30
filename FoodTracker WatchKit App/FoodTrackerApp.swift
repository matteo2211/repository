import SwiftUI

@main
struct FoodTrackerApp: App {
    @StateObject private var foodTracker = FoodTracker()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .environmentObject(foodTracker)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                
                HistoryView(foodTracker: foodTracker)
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Cronologia")
                    }
            }
        }
    }
}