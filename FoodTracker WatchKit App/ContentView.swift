import SwiftUI
import WatchKit

struct ContentView: View {
    @StateObject private var foodTracker = FoodTracker()
    @State private var showingAddFood = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Loading indicator
                if foodTracker.isLoadingFoods {
                    VStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Caricamento alimenti...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                
                // Error message
                if let error = foodTracker.loadingError {
                    VStack {
                        Text("⚠️")
                            .font(.title2)
                        Text(error)
                            .font(.caption2)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button("Riprova") {
                            foodTracker.loadFoodsFromCSV()
                        }
                        .font(.caption2)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .padding()
                }
                
                // Daily nutrition summary
                let nutrition = foodTracker.dailyNutrition
                VStack(spacing: 8) {
                    Text("Oggi")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(nutrition.calories)")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("kcal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    // Macronutrients chips
                    HStack(spacing: 6) {
                        MacroChip(label: "P", value: nutrition.proteine, color: .blue)
                        MacroChip(label: "G", value: nutrition.grassi, color: .orange)
                        MacroChip(label: "C", value: nutrition.carboidrati, color: .green)
                    }
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
                    .background(foodTracker.availableFoods.isEmpty ? Color.gray : Color.green)
                    .cornerRadius(20)
                }
                .disabled(foodTracker.availableFoods.isEmpty)
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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.food.categoryEnum.icon)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.food.nome)
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
            
            // Macronutrients
            HStack(spacing: 8) {
                MacroChip(label: "P", value: entry.proteine, color: .blue)
                MacroChip(label: "G", value: entry.grassi, color: .orange)
                MacroChip(label: "C", value: entry.carboidrati, color: .green)
            }
        }
        .padding(.vertical, 2)
    }
}

struct MacroChip: View {
    let label: String
    let value: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: 2) {
            Text(label)
                .font(.caption2)
                .fontWeight(.bold)
                .foregroundColor(color)
            
            Text("\(value, specifier: "%.1f")")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(color.opacity(0.1))
        .cornerRadius(4)
    }
}

#Preview {
    ContentView()
}