import SwiftUI

struct AddFoodView: View {
    @ObservedObject var foodTracker: FoodTracker
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedFood: Food?
    @State private var quantity: Double = 100
    @State private var searchText = ""
    @State private var selectedCategory: Food.FoodCategory = .fruits
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category picker
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Food.FoodCategory.allCases, id: \.self) { category in
                            CategoryButton(
                                category: category,
                                isSelected: selectedCategory == category
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
                            Text("\(Int((food.caloriesPer100g * quantity) / 100)) kcal")
                                .font(.caption)
                                .foregroundColor(.blue)
                                .fontWeight(.medium)
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
        FoodDatabase.foods.filter { food in
            food.category == selectedCategory &&
            (searchText.isEmpty || food.name.localizedCaseInsensitiveContains(searchText))
        }
    }
}

struct CategoryButton: View {
    let category: Food.FoodCategory
    let isSelected: Bool
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
        }
        .buttonStyle(PlainButtonStyle())
        .foregroundColor(isSelected ? .blue : .primary)
    }
}

struct FoodSelectionRow: View {
    let food: Food
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(food.category.icon)
                    .font(.title3)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(food.name)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text("\(Int(food.caloriesPer100g)) kcal/100g")
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
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .background(isSelected ? Color.green.opacity(0.1) : Color.clear)
        .cornerRadius(8)
    }
}

#Preview {
    AddFoodView(foodTracker: FoodTracker())
}