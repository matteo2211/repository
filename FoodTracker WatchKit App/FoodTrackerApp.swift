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
                
                NutritionSummaryView(foodTracker: foodTracker)
                    .tabItem {
                        Image(systemName: "chart.pie.fill")
                        Text("Nutrizione")
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