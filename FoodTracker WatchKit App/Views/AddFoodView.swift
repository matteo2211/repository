import SwiftUI

struct AddFoodView: View {
    @ObservedObject var foodTracker: FoodTracker
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedFood: Food?
    @State private var quantity: Double = 100
    @State private var searchText = ""
    @State private var selectedCategory: Food.FoodCategory = .frutta
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Loading or error state
                if foodTracker.isLoadingFoods {
                    VStack {
                        ProgressView()
                            .scaleEffect(0.8)
                        Text("Caricamento...")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else if let error = foodTracker.loadingError {
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
                } else {
                    // Category picker
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(Food.FoodCategory.allCases, id: \.self) { category in
                                CategoryButton(
                                    category: category,
                                    isSelected: selectedCategory == category,
                                    hasItems: !foodsByCategory(category).isEmpty
                                ) {
                                    selectedCategory = category
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical, 8)
                    
                    // Food list
                    List {
                        ForEach(filteredFoods) { food in
                            FoodSelectionRow(
                                food: food,
                                isSelected: selectedFood?.id == food.id
                            ) {
                                selectedFood = food
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    // Quantity input and add button
                    if selectedFood != nil {
                        VStack(spacing: 12) {
                            HStack {
                                Text("Quantità:")
                                    .font(.caption)
                                Spacer()
                                Text("\(Int(quantity))g")
                                    .font(.caption)
                                    .fontWeight(.medium)
                            }
                            
                            Slider(value: $quantity, in: 10...500, step: 10)
                                .accentColor(.green)
                            
                            if let food = selectedFood {
                                // Nutrition preview
                                VStack(spacing: 4) {
                                    Text("\(Int((food.calorie * quantity) / 100)) kcal")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                        .fontWeight(.medium)
                                    
                                    HStack(spacing: 8) {
                                        MacroPreview(label: "P", value: (food.proteine * quantity) / 100, color: .blue)
                                        MacroPreview(label: "G", value: (food.grassi * quantity) / 100, color: .orange)
                                        MacroPreview(label: "C", value: (food.carboidrati * quantity) / 100, color: .green)
                                    }
                                }
                            }
                            
                            Button("Aggiungi") {
                                if let food = selectedFood {
                                    foodTracker.addFoodEntry(food, quantity: quantity)
                                    dismiss()
                                }
                            }
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                            .background(Color.green)
                            .cornerRadius(20)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                    }
                }
            }
            .navigationTitle("Aggiungi Cibo")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Annulla") {
                        dismiss()
                    }
                    .font(.caption)
                }
            }
        }
    }
    
    private var filteredFoods: [Food] {
        let categoryFoods = foodsByCategory(selectedCategory)
        
        if searchText.isEmpty {
            return categoryFoods
        } else {
            return categoryFoods.filter { food in
                food.nome.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    private func foodsByCategory(_ category: Food.FoodCategory) -> [Food] {
        return foodTracker.availableFoods.filter { food in
            food.categoryEnum == category
        }.sorted { $0.nome < $1.nome }
    }
}

struct CategoryButton: View {
    let category: Food.FoodCategory
    let isSelected: Bool
    let hasItems: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text(category.icon)
                    .font(.title3)
                
                Text(category.rawValue)
                    .font(.caption2)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(isSelected ? Color.blue.opacity(0.2) : Color.clear)
            .cornerRadius(8)
            .opacity(hasItems ? 1.0 : 0.5)
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isSelected ? .blue : .primary)
        .disabled(!hasItems)
    }
}

struct FoodSelectionRow: View {
    let food: Food
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(food.categoryEnum.icon)
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(food.nome)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        
                        Text("\(Int(food.calorie)) kcal/100g")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.caption)
                    }
                }
                
                // Macronutrients preview
                HStack(spacing: 8) {
                    MacroPreview(label: "P", value: food.proteine, color: .blue)
                    MacroPreview(label: "G", value: food.grassi, color: .orange)
                    MacroPreview(label: "C", value: food.carboidrati, color: .green)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .background(isSelected ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

struct MacroPreview: View {
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
    AddFoodView(foodTracker: FoodTracker())
}