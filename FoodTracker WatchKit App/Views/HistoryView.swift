import SwiftUI

struct HistoryView: View {
    @ObservedObject var foodTracker: FoodTracker
    @State private var selectedDate = Date()
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Weekly chart
                VStack(alignment: .leading, spacing: 8) {
                    Text("Ultimi 7 giorni")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    WeeklyCalorieChart(weeklyCalories: foodTracker.getWeeklyCalories())
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Date picker
                DatePicker(
                    "Seleziona data",
                    selection: $selectedDate,
                    displayedComponents: .date
                )
                .datePickerStyle(CompactDatePickerStyle())
                .font(.caption)
                
                // Food entries for selected date
                List {
                    ForEach(foodEntriesForDate(selectedDate)) { entry in
                        HistoryFoodRow(entry: entry)
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
            .navigationTitle("Cronologia")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func foodEntriesForDate(_ date: Date) -> [FoodEntry] {
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return foodTracker.foodEntries
            .filter { entry in
                entry.timestamp >= startOfDay && entry.timestamp < endOfDay
            }
            .sorted { $0.timestamp > $1.timestamp }
    }
}

struct WeeklyCalorieChart: View {
    let weeklyCalories: [Int]
    
    private let maxCalories: Int = 2500
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(0..<weeklyCalories.count, id: \.self) { index in
                VStack(spacing: 4) {
                    // Bar
                    Rectangle()
                        .fill(colorForCalories(weeklyCalories[index]))
                        .frame(width: 20, height: max(4, CGFloat(weeklyCalories[index]) / CGFloat(maxCalories) * 60))
                        .cornerRadius(2)
                    
                    // Day label
                    Text(dayLabel(for: index))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .frame(height: 80)
    }
    
    private func colorForCalories(_ calories: Int) -> Color {
        switch calories {
        case 0..<500:
            return .red.opacity(0.6)
        case 500..<1500:
            return .orange.opacity(0.7)
        case 1500..<2000:
            return .green.opacity(0.7)
        case 2000..<2500:
            return .blue.opacity(0.7)
        default:
            return .purple.opacity(0.7)
        }
    }
    
    private func dayLabel(for index: Int) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let date = calendar.date(byAdding: .day, value: index - 6, to: today)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        formatter.locale = Locale(identifier: "it_IT")
        return formatter.string(from: date).prefix(1).uppercased()
    }
}

struct HistoryFoodRow: View {
    let entry: FoodEntry
    
    var body: some View {
        HStack {
            Text(entry.food.category.icon)
                .font(.title3)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.food.name)
                    .font(.caption)
                    .fontWeight(.medium)
                
                HStack {
                    Text("\(Int(entry.quantity))g")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(timeString(from: entry.timestamp))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text("\(entry.calories) kcal")
                .font(.caption2)
                .fontWeight(.medium)
                .foregroundColor(.blue)
        }
        .padding(.vertical, 4)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView(foodTracker: FoodTracker())
}