import SwiftUI

struct NutritionSummaryView: View {
    @State private var dailyCalories: Int = 0
    @State private var targetCalories: Int = 2000
    @State private var protein: Double = 0
    @State private var carbs: Double = 0
    @State private var fat: Double = 0
    @State private var targetProtein: Double = 150
    @State private var targetCarbs: Double = 250
    @State private var targetFat: Double = 67
    
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                // Header
                Text("Nutrition Summary")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                // Calories Progress
                VStack(spacing: 4) {
                    HStack {
                        Text("Calories")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(dailyCalories)/\(targetCalories)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: Double(dailyCalories), total: Double(targetCalories))
                        .progressViewStyle(LinearProgressViewStyle(tint: calorieProgressColor))
                        .scaleEffect(y: 2)
                }
                .padding(.horizontal, 4)
                
                Divider()
                
                // Macronutrients
                VStack(spacing: 8) {
                    MacroRow(
                        name: "Protein",
                        current: protein,
                        target: targetProtein,
                        unit: "g",
                        color: .blue
                    )
                    
                    MacroRow(
                        name: "Carbs",
                        current: carbs,
                        target: targetCarbs,
                        unit: "g",
                        color: .orange
                    )
                    
                    MacroRow(
                        name: "Fat",
                        current: fat,
                        target: targetFat,
                        unit: "g",
                        color: .purple
                    )
                }
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 8)
        }
        .navigationTitle("Nutrition")
        .onAppear {
            loadNutritionData()
        }
    }
    
    private var calorieProgressColor: Color {
        let progress = Double(dailyCalories) / Double(targetCalories)
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.7 {
            return .yellow
        } else {
            return .red
        }
    }
    
    private func loadNutritionData() {
        // TODO: Load actual nutrition data from your data source
        // This is placeholder data for demonstration
        dailyCalories = 1450
        protein = 85.5
        carbs = 180.2
        fat = 45.8
    }
}

struct MacroRow: View {
    let name: String
    let current: Double
    let target: Double
    let unit: String
    let color: Color
    
    private var progress: Double {
        current / target
    }
    
    private var progressColor: Color {
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.8 {
            return color
        } else {
            return color.opacity(0.6)
        }
    }
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(name)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(current, specifier: "%.1f")/\(target, specifier: "%.0f")\(unit)")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: min(progress, 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: progressColor))
                .scaleEffect(y: 1.5)
        }
        .padding(.horizontal, 4)
    }
}

#Preview {
    NavigationView {
        NutritionSummaryView()
    }
}