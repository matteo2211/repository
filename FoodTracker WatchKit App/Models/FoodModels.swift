import Foundation
import SwiftUI

// MARK: - Food Item Model
struct Food: Identifiable, Codable, Hashable {
    let id = UUID()
    let categoria: String
    let nome: String
    let tipo: String
    let peso: Double
    let proteine: Double      // per 100g
    let grassi: Double        // per 100g
    let carboidrati: Double   // per 100g
    let calorie: Double       // per 100g
    
    // Computed property for category enum
    var categoryEnum: FoodCategory {
        return FoodCategory.fromString(categoria)
    }
    
    enum FoodCategory: String, CaseIterable, Codable {
        case frutta = "Frutta"
        case verdure = "Verdure"
        case cereali = "Cereali"
        case proteine = "Proteine"
        case latticini = "Latticini"
        case snack = "Snack"
        case bevande = "Bevande"
        case altro = "Altro"
        
        var icon: String {
            switch self {
            case .frutta: return "🍎"
            case .verdure: return "🥕"
            case .cereali: return "🌾"
            case .proteine: return "🥩"
            case .latticini: return "🥛"
            case .snack: return "🍪"
            case .bevande: return "🥤"
            case .altro: return "🍽️"
            }
        }
        
        static func fromString(_ string: String) -> FoodCategory {
            switch string.lowercased() {
            case "frutta": return .frutta
            case "verdure", "verdura": return .verdure
            case "cereali", "cereale": return .cereali
            case "proteine", "proteina": return .proteine
            case "latticini", "latticino": return .latticini
            case "snack": return .snack
            case "bevande", "bevanda": return .bevande
            default: return .altro
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
    
    // Calculated nutritional values based on quantity
    var calories: Int {
        Int((food.calorie * quantity) / 100)
    }
    
    var proteine: Double {
        (food.proteine * quantity) / 100
    }
    
    var grassi: Double {
        (food.grassi * quantity) / 100
    }
    
    var carboidrati: Double {
        (food.carboidrati * quantity) / 100
    }
    
    init(food: Food, quantity: Double, timestamp: Date = Date()) {
        self.food = food
        self.quantity = quantity
        self.timestamp = timestamp
    }
}

// MARK: - Daily Nutrition Summary
struct DailyNutrition {
    let calories: Int
    let proteine: Double
    let grassi: Double
    let carboidrati: Double
    let date: Date
    
    init(from entries: [FoodEntry]) {
        self.calories = entries.reduce(0) { $0 + $1.calories }
        self.proteine = entries.reduce(0) { $0 + $1.proteine }
        self.grassi = entries.reduce(0) { $0 + $1.grassi }
        self.carboidrati = entries.reduce(0) { $0 + $1.carboidrati }
        self.date = entries.first?.timestamp ?? Date()
    }
}

// MARK: - Food Tracker ObservableObject
class FoodTracker: ObservableObject {
    @Published var foodEntries: [FoodEntry] = []
    @Published var availableFoods: [Food] = []
    @Published var isLoadingFoods = false
    @Published var loadingError: String?
    
    private let userDefaults = UserDefaults.standard
    private let entriesKey = "FoodEntries"
    private let foodsKey = "CachedFoods"
    private let foodsLastUpdateKey = "FoodsLastUpdate"
    
    init() {
        loadEntries()
        loadCachedFoods()
        // Load foods from CSV on first launch or if cache is old
        if shouldUpdateFoods() {
            loadFoodsFromCSV()
        }
    }
    
    // MARK: - Computed Properties
    var todaysFoods: [FoodEntry] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
        
        return foodEntries.filter { entry in
            entry.timestamp >= today && entry.timestamp < tomorrow
        }.sorted { $0.timestamp > $1.timestamp }
    }
    
    var dailyNutrition: DailyNutrition {
        DailyNutrition(from: todaysFoods)
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
    
    func getNutritionForDate(_ date: Date) -> DailyNutrition {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let dayEntries = foodEntries.filter { entry in
            entry.timestamp >= startOfDay && entry.timestamp < endOfDay
        }
        
        return DailyNutrition(from: dayEntries)
    }
    
    func getWeeklyCalories() -> [Int] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var weeklyCalories: [Int] = []
        
        for i in 0..<7 {
            let date = calendar.date(byAdding: .day, value: -i, to: today)!
            let nutrition = getNutritionForDate(date)
            weeklyCalories.insert(nutrition.calories, at: 0)
        }
        
        return weeklyCalories
    }
    
    // MARK: - CSV Loading
    func loadFoodsFromCSV() {
        guard let url = URL(string: "https://docs.google.com/spreadsheets/d/1gfW5-oZqfTw8J3Ss5hsKAdRcMxlIHT_rEp56Gi7lUYA/export?format=csv&gid=939079319") else {
            loadingError = "URL non valido"
            return
        }
        
        isLoadingFoods = true
        loadingError = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoadingFoods = false
                
                if let error = error {
                    self?.loadingError = "Errore di rete: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.loadingError = "Nessun dato ricevuto"
                    return
                }
                
                do {
                    let foods = try self?.parseCSVData(data) ?? []
                    self?.availableFoods = foods
                    self?.cacheFoods(foods)
                    self?.markFoodsAsUpdated()
                } catch {
                    self?.loadingError = "Errore parsing CSV: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func parseCSVData(_ data: Data) throws -> [Food] {
        guard let csvString = String(data: data, encoding: .utf8) else {
            throw NSError(domain: "CSVError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Impossibile convertire i dati in stringa"])
        }
        
        let lines = csvString.components(separatedBy: .newlines)
        var foods: [Food] = []
        
        // Skip header line
        for line in lines.dropFirst() {
            guard !line.isEmpty else { continue }
            
            let components = line.components(separatedBy: ",")
            guard components.count >= 10 else { continue }
            
            // Parse CSV columns: Categoria, Nome, Tipo, Peso, Proteine, Grassi, Carboidrati, Acqua, Fibre, Calorie
            let categoria = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
            let nome = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
            let tipo = components[2].trimmingCharacters(in: .whitespacesAndNewlines)
            
            guard let peso = Double(components[3].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let proteine = Double(components[4].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let grassi = Double(components[5].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let carboidrati = Double(components[6].trimmingCharacters(in: .whitespacesAndNewlines)),
                  let calorie = Double(components[9].trimmingCharacters(in: .whitespacesAndNewlines)) else {
                continue
            }
            
            let food = Food(
                categoria: categoria,
                nome: nome,
                tipo: tipo,
                peso: peso,
                proteine: proteine,
                grassi: grassi,
                carboidrati: carboidrati,
                calorie: calorie
            )
            
            foods.append(food)
        }
        
        return foods
    }
    
    // MARK: - Caching
    private func shouldUpdateFoods() -> Bool {
        guard let lastUpdate = userDefaults.object(forKey: foodsLastUpdateKey) as? Date else {
            return true // First time
        }
        
        // Update if cache is older than 24 hours
        return Date().timeIntervalSince(lastUpdate) > 24 * 60 * 60
    }
    
    private func cacheFoods(_ foods: [Food]) {
        if let encoded = try? JSONEncoder().encode(foods) {
            userDefaults.set(encoded, forKey: foodsKey)
        }
    }
    
    private func loadCachedFoods() {
        if let data = userDefaults.data(forKey: foodsKey),
           let foods = try? JSONDecoder().decode([Food].self, from: data) {
            self.availableFoods = foods
        }
    }
    
    private func markFoodsAsUpdated() {
        userDefaults.set(Date(), forKey: foodsLastUpdateKey)
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