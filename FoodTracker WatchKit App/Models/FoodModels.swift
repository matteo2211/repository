import Foundation
import SwiftUI

// MARK: - Food Item Model
struct Food: Identifiable, Codable, Hashable {
    let id = UUID()
    let name: String
    let caloriesPer100g: Double
    let category: FoodCategory
    
    enum FoodCategory: String, CaseIterable, Codable {
        case fruits = "Frutta"
        case vegetables = "Verdure"
        case grains = "Cereali"
        case proteins = "Proteine"
        case dairy = "Latticini"
        case snacks = "Snack"
        case beverages = "Bevande"
        case other = "Altro"
        
        var icon: String {
            switch self {
            case .fruits: return "🍎"
            case .vegetables: return "🥕"
            case .grains: return "🌾"
            case .proteins: return "🥩"
            case .dairy: return "🥛"
            case .snacks: return "🍪"
            case .beverages: return "🥤"
            case .other: return "🍽️"
            }
        }
    }
}

// MARK: - Food Entry Model
struct FoodEntry: Identifiable, Codable {
    let id = UUID()
    let food: Food
    let quantity: Double // in grams
    let timestamp: Date
    
    var calories: Int {
        Int((food.caloriesPer100g * quantity) / 100)
    }
    
    init(food: Food, quantity: Double, timestamp: Date = Date()) {
        self.food = food
        self.quantity = quantity
        self.timestamp = timestamp
    }
}

// MARK: - Food Tracker ObservableObject
class FoodTracker: ObservableObject {
    @Published var foodEntries: [FoodEntry] = []
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "FoodEntries"
    
    init() {
        loadEntries()
    }
    
    // MARK: - Computed Properties
    var todaysFoods: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return foodEntries.filter { entry in
            entry.timestamp >= today && entry.timestamp < tomorrow
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    var dailyCalories: Int {
        todaysFoods.reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Methods
    func addFoodEntry(_ food: Food, quantity: Double) {
        let entry = FoodEntry(food: food, quantity: quantity)
        foodEntries.append(entry)
        saveEntries()
    }
    
    func removeFoodEntry(_ entry: FoodEntry) {
        foodEntries.removeAll { $0.id == entry.id }
        saveEntries()
    }
    
    func getWeeklyCalories() -> [Int] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var weeklyCalories: [Int] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let nextDay = calendar.date(byAdding: .day, value: 1, to: date)!
            
            let dayEntries = foodEntries.filter { entry in
                entry.timestamp >= date && entry.timestamp < nextDay
            }
            
            let dayCalories = dayEntries.reduce(0) { $0 + $1.calories }
            weeklyCalories.insert(dayCalories, at: 0)
        }
        
        return weeklyCalories
    }
    
    // MARK: - Persistence
    private func saveEntries() {
        if let encoded = try? JSONEncoder().encode(foodEntries) {
            userDefaults.set(encoded, forKey: entriesKey)
        }
    }
    
    private func loadEntries() {
        if let data = userDefaults.data(forKey: entriesKey),
           let entries = try? JSONDecoder().decode([FoodEntry].self, from: data) {
            self.foodEntries = entries
        }
    }
}