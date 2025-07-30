import Foundation

struct FoodDatabase {
    static let foods: [Food] = [
        // MARK: - Frutta
        Food(name: "Mela", caloriesPer100g: 52, category: .fruits),
        Food(name: "Banana", caloriesPer100g: 89, category: .fruits),
        Food(name: "Arancia", caloriesPer100g: 47, category: .fruits),
        Food(name: "Pera", caloriesPer100g: 57, category: .fruits),
        Food(name: "Fragole", caloriesPer100g: 32, category: .fruits),
        Food(name: "Uva", caloriesPer100g: 62, category: .fruits),
        Food(name: "Pesca", caloriesPer100g: 39, category: .fruits),
        Food(name: "Albicocca", caloriesPer100g: 48, category: .fruits),
        Food(name: "Kiwi", caloriesPer100g: 61, category: .fruits),
        Food(name: "Ananas", caloriesPer100g: 50, category: .fruits),
        Food(name: "Limone", caloriesPer100g: 29, category: .fruits),
        Food(name: "Mandarino", caloriesPer100g: 53, category: .fruits),
        Food(name: "Melone", caloriesPer100g: 34, category: .fruits),
        Food(name: "Anguria", caloriesPer100g: 30, category: .fruits),
        Food(name: "Ciliegie", caloriesPer100g: 63, category: .fruits),
        
        // MARK: - Verdure
        Food(name: "Pomodoro", caloriesPer100g: 18, category: .vegetables),
        Food(name: "Carote", caloriesPer100g: 41, category: .vegetables),
        Food(name: "Zucchine", caloriesPer100g: 17, category: .vegetables),
        Food(name: "Melanzane", caloriesPer100g: 25, category: .vegetables),
        Food(name: "Peperoni", caloriesPer100g: 31, category: .vegetables),
        Food(name: "Spinaci", caloriesPer100g: 23, category: .vegetables),
        Food(name: "Lattuga", caloriesPer100g: 15, category: .vegetables),
        Food(name: "Broccoli", caloriesPer100g: 34, category: .vegetables),
        Food(name: "Cavolfiore", caloriesPer100g: 25, category: .vegetables),
        Food(name: "Cetriolo", caloriesPer100g: 16, category: .vegetables),
        Food(name: "Cipolla", caloriesPer100g: 40, category: .vegetables),
        Food(name: "Aglio", caloriesPer100g: 149, category: .vegetables),
        Food(name: "Patate", caloriesPer100g: 77, category: .vegetables),
        Food(name: "Patate dolci", caloriesPer100g: 86, category: .vegetables),
        Food(name: "Fagiolini", caloriesPer100g: 31, category: .vegetables),
        
        // MARK: - Cereali
        Food(name: "Pasta", caloriesPer100g: 131, category: .grains),
        Food(name: "Riso", caloriesPer100g: 130, category: .grains),
        Food(name: "Pane bianco", caloriesPer100g: 265, category: .grains),
        Food(name: "Pane integrale", caloriesPer100g: 247, category: .grains),
        Food(name: "Avena", caloriesPer100g: 389, category: .grains),
        Food(name: "Quinoa", caloriesPer100g: 120, category: .grains),
        Food(name: "Farro", caloriesPer100g: 340, category: .grains),
        Food(name: "Orzo", caloriesPer100g: 354, category: .grains),
        Food(name: "Cereali per colazione", caloriesPer100g: 379, category: .grains),
        Food(name: "Crackers", caloriesPer100g: 502, category: .grains),
        Food(name: "Fette biscottate", caloriesPer100g: 410, category: .grains),
        
        // MARK: - Proteine
        Food(name: "Pollo (petto)", caloriesPer100g: 165, category: .proteins),
        Food(name: "Manzo", caloriesPer100g: 250, category: .proteins),
        Food(name: "Maiale", caloriesPer100g: 242, category: .proteins),
        Food(name: "Salmone", caloriesPer100g: 208, category: .proteins),
        Food(name: "Tonno", caloriesPer100g: 144, category: .proteins),
        Food(name: "Uova", caloriesPer100g: 155, category: .proteins),
        Food(name: "Fagioli", caloriesPer100g: 127, category: .proteins),
        Food(name: "Lenticchie", caloriesPer100g: 116, category: .proteins),
        Food(name: "Ceci", caloriesPer100g: 164, category: .proteins),
        Food(name: "Tofu", caloriesPer100g: 76, category: .proteins),
        Food(name: "Prosciutto", caloriesPer100g: 145, category: .proteins),
        Food(name: "Bresaola", caloriesPer100g: 151, category: .proteins),
        Food(name: "Mozzarella", caloriesPer100g: 280, category: .proteins),
        
        // MARK: - Latticini
        Food(name: "Latte intero", caloriesPer100g: 61, category: .dairy),
        Food(name: "Latte scremato", caloriesPer100g: 35, category: .dairy),
        Food(name: "Yogurt naturale", caloriesPer100g: 59, category: .dairy),
        Food(name: "Yogurt greco", caloriesPer100g: 97, category: .dairy),
        Food(name: "Formaggio stagionato", caloriesPer100g: 393, category: .dairy),
        Food(name: "Ricotta", caloriesPer100g: 174, category: .dairy),
        Food(name: "Parmigiano", caloriesPer100g: 431, category: .dairy),
        Food(name: "Gorgonzola", caloriesPer100g: 353, category: .dairy),
        Food(name: "Burro", caloriesPer100g: 717, category: .dairy),
        Food(name: "Panna", caloriesPer100g: 337, category: .dairy),
        
        // MARK: - Snack
        Food(name: "Mandorle", caloriesPer100g: 579, category: .snacks),
        Food(name: "Noci", caloriesPer100g: 654, category: .snacks),
        Food(name: "Nocciole", caloriesPer100g: 628, category: .snacks),
        Food(name: "Pistacchi", caloriesPer100g: 560, category: .snacks),
        Food(name: "Biscotti", caloriesPer100g: 502, category: .snacks),
        Food(name: "Cioccolato fondente", caloriesPer100g: 546, category: .snacks),
        Food(name: "Cioccolato al latte", caloriesPer100g: 534, category: .snacks),
        Food(name: "Gelato", caloriesPer100g: 207, category: .snacks),
        Food(name: "Patatine", caloriesPer100g: 536, category: .snacks),
        Food(name: "Pop corn", caloriesPer100g: 387, category: .snacks),
        
        // MARK: - Bevande
        Food(name: "Acqua", caloriesPer100g: 0, category: .beverages),
        Food(name: "Caffè", caloriesPer100g: 2, category: .beverages),
        Food(name: "Tè", caloriesPer100g: 1, category: .beverages),
        Food(name: "Succo d'arancia", caloriesPer100g: 45, category: .beverages),
        Food(name: "Coca Cola", caloriesPer100g: 42, category: .beverages),
        Food(name: "Birra", caloriesPer100g: 43, category: .beverages),
        Food(name: "Vino rosso", caloriesPer100g: 85, category: .beverages),
        Food(name: "Vino bianco", caloriesPer100g: 82, category: .beverages),
        Food(name: "Spremuta di limone", caloriesPer100g: 22, category: .beverages),
        
        // MARK: - Altro
        Food(name: "Olio d'oliva", caloriesPer100g: 884, category: .other),
        Food(name: "Zucchero", caloriesPer100g: 387, category: .other),
        Food(name: "Miele", caloriesPer100g: 304, category: .other),
        Food(name: "Nutella", caloriesPer100g: 539, category: .other),
        Food(name: "Marmellata", caloriesPer100g: 278, category: .other),
        Food(name: "Aceto balsamico", caloriesPer100g: 88, category: .other),
        Food(name: "Sale", caloriesPer100g: 0, category: .other),
        Food(name: "Pepe", caloriesPer100g: 251, category: .other),
        Food(name: "Basilico", caloriesPer100g: 22, category: .other),
        Food(name: "Prezzemolo", caloriesPer100g: 36, category: .other)
    ]
    
    // MARK: - Helper Methods
    static func searchFoods(query: String) -> [Food] {
        if query.isEmpty {
            return foods
        }
        return foods.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
    
    static func foodsByCategory(_ category: Food.FoodCategory) -> [Food] {
        return foods.filter { $0.category == category }
    }
    
    static func popularFoods() -> [Food] {
        // Return some commonly used foods
        return [
            foods.first { $0.name == "Pasta" }!,
            foods.first { $0.name == "Riso" }!,
            foods.first { $0.name == "Pollo (petto)" }!,
            foods.first { $0.name == "Mela" }!,
            foods.first { $0.name == "Pane bianco" }!,
            foods.first { $0.name == "Latte intero" }!,
            foods.first { $0.name == "Yogurt naturale" }!,
            foods.first { $0.name == "Banana" }!
        ]
    }
}