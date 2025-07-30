import SwiftUI
import WatchKit

struct ContentView: View {
    @StateObject private var foodTracker = FoodTracker()
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Daily calorie summary
                VStack {
                    Text("Calorie Oggi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(foodTracker.dailyCalories)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("kcal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                
                Spacer()
                
                // Recent foods list
                if !foodTracker.todaysFoods.isEmpty {
                    List {
                        ForEach(foodTracker.todaysFoods) { entry in
                            FoodEntryRow(entry: entry)
                        }
                        .onDelete(perform: deleteFoodEntry)
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Text("Nessun cibo registrato oggi")
                        .foregroundColor(.secondary)
                        .font(.caption)
                }
                
                Spacer()
                
                // Add food button
                Button(action: {
                    showingAddFood = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Aggiungi Cibo")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color.green)
                    .cornerRadius(20)
                }
            }
            .navigationTitle("Food Tracker")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingAddFood) {
            AddFoodView(foodTracker: foodTracker)
        }
    }
    
    private func deleteFoodEntry(at offsets: IndexSet) {
        for index in offsets {
            let entry = foodTracker.todaysFoods[index]
            foodTracker.removeFoodEntry(entry)
        }
    }
}

struct FoodEntryRow: View {
    let entry: FoodEntry
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.food.name)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text("\(entry.quantity, specifier: "%.0f")g")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text("\(entry.calories) kcal")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    ContentView()
}