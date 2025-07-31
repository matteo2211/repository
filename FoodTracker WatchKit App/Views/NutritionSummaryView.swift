import SwiftUI

struct NutritionSummaryView: View {
    @ObservedObject var foodTracker: FoodTracker
    @State private var selectedDate = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Date picker
                DatePicker(
                    "Data",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .font(.caption)
                
                // Nutrition cards
                let nutrition = foodTracker.getNutritionForDate(selectedDate)
                
                VStack(spacing: 12) {
                    // Calories card
                    NutritionCard(
                        title: "Calorie",
                        value: "\(nutrition.calories)",
                        unit: "kcal",
                        color: .red,
                        icon: "flame.fill"
                    )
                    
                    // Macronutrients row
                    HStack(spacing: 8) {
                        NutritionCard(
                            title: "Proteine",
                            value: String(format: "%.1f", nutrition.proteine),
                            unit: "g",
                            color: .blue,
                            icon: "drop.fill",
                            isCompact: true
                        )
                        
                        NutritionCard(
                            title: "Grassi",
                            value: String(format: "%.1f", nutrition.grassi),
                            unit: "g",
                            color: .orange,
                            icon: "circle.fill",
                            isCompact: true
                        )
                        
                        NutritionCard(
                            title: "Carboidrati",
                            value: String(format: "%.1f", nutrition.carboidrati),
                            unit: "g",
                            color: .green,
                            icon: "leaf.fill",
                            isCompact: true
                        )
                    }
                }
                
                // Macronutrient breakdown chart
                if nutrition.calories > 0 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Ripartizione Macronutrienti")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        MacronutrientChart(nutrition: nutrition)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                }
                
                // Food entries list for selected date
                List {
                    ForEach(foodEntriesForDate(selectedDate)) { entry in
                        NutritionFoodRow(entry: entry)
                    }
                }
                .listStyle(PlainListStyle())
                
                if foodEntriesForDate(selectedDate).isEmpty {
                    Text("Nessun cibo registrato")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .padding()
                }
                
                Spacer()
            }
            .navigationTitle("Nutrizione")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func foodEntriesForDate(_ date: Date) -> [FoodEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return foodTracker.foodEntries
            .filter { entry in
                entry.timestamp >= startOfDay && entry.timestamp < endOfDay
            }
            .sorted { $0.timestamp > $1.timestamp }
    }
}

struct NutritionCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    let icon: String
    var isCompact: Bool = false
    
    var body: some View {
        VStack(spacing: isCompact ? 4 : 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(isCompact ? .caption2 : .caption)
                
                Text(title)
                    .font(isCompact ? .caption2 : .caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
            }
            
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(isCompact ? .caption : .title3)
                    .fontWeight(.bold)
                    .foregroundColor(color)
                
                Text(unit)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(isCompact ? 8 : 12)
        .background(color.opacity(0.1))
        .cornerRadius(8)
        .frame(maxWidth: .infinity)
    }
}

struct MacronutrientChart: View {
    let nutrition: DailyNutrition
    
    private var totalGrams: Double {
        nutrition.proteine + nutrition.grassi + nutrition.carboidrati
    }
    
    private var proteinePercentage: Double {
        totalGrams > 0 ? (nutrition.proteine / totalGrams) * 100 : 0
    }
    
    private var grassiPercentage: Double {
        totalGrams > 0 ? (nutrition.grassi / totalGrams) * 100 : 0
    }
    
    private var carboidratiPercentage: Double {
        totalGrams > 0 ? (nutrition.carboidrati / totalGrams) * 100 : 0
    }
    
    var body: some View {
        VStack(spacing: 8) {
            // Progress bars
            VStack(spacing: 4) {
                MacroBar(
                    label: "Proteine",
                    percentage: proteinePercentage,
                    color: .blue,
                    grams: nutrition.proteine
                )
                
                MacroBar(
                    label: "Grassi",
                    percentage: grassiPercentage,
                    color: .orange,
                    grams: nutrition.grassi
                )
                
                MacroBar(
                    label: "Carboidrati",
                    percentage: carboidratiPercentage,
                    color: .green,
                    grams: nutrition.carboidrati
                )
            }
        }
    }
}

struct MacroBar: View {
    let label: String
    let percentage: Double
    let color: Color
    let grams: Double
    
    var body: some View {
        HStack {
            Text(label)
                .font(.caption2)
                .frame(width: 60, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 6)
                        .cornerRadius(3)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * CGFloat(percentage / 100), height: 6)
                        .cornerRadius(3)
                }
            }
            .frame(height: 6)
            
            Text("\(grams, specifier: "%.1f")g")
                .font(.caption2)
                .foregroundColor(.secondary)
                .frame(width: 35, alignment: .trailing)
        }
    }
}

struct NutritionFoodRow: View {
    let entry: FoodEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.food.categoryEnum.icon)
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(entry.food.nome)
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("\(Int(entry.quantity))g • \(timeString(from: entry.timestamp))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text("\(entry.calories) kcal")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(.red)
            }
            
            // Macronutrients breakdown
            HStack(spacing: 12) {
                MacroChip(label: "P", value: entry.proteine, color: .blue)
                MacroChip(label: "G", value: entry.grassi, color: .orange)
                MacroChip(label: "C", value: entry.carboidrati, color: .green)
            }
        }
        .padding(.vertical, 2)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
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
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(color.opacity(0.1))
        .cornerRadius(4)
    }
}

#Preview {
    NutritionSummaryView(foodTracker: FoodTracker())
}