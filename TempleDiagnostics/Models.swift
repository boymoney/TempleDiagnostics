import Foundation

// Enumeration to represent diet recommendations with Codable conformance for easy encoding and decoding
enum DietRecommendation: String, Codable {
    case red     // Indicates the item is not recommended for the diet
    case yellow  // Indicates the item is moderately recommended for the diet
    case green   // Indicates the item is recommended for the diet
    case unknown // Indicates the recommendation status is unknown
}

// Struct to represent a menu item with Codable conformance for easy encoding and decoding
struct MenuItem: Codable {
    let name: String                     // Name of the menu item
    var dietRecommendation: DietRecommendation // Diet recommendation for the menu item
}

// Struct to represent a nutrient with Codable conformance for easy encoding and decoding
struct Nutrient: Codable {
    let id: Int          // Unique identifier for the nutrient
    let number: String   // Nutrient number
    let name: String     // Name of the nutrient
    let rank: Int        // Rank of the nutrient
    let unitName: String // Unit of measurement for the nutrient
}

// Struct to represent a food nutrient with Codable conformance for easy encoding and decoding
struct FoodNutrient: Codable {
    let type: String    // Type of the food nutrient
    let id: Int         // Unique identifier for the food nutrient
    let nutrient: Nutrient // Nutrient information
    let amount: Double? // Amount of the nutrient, optional
}

// Struct to represent a food item with Codable conformance for easy encoding and decoding
struct FoodItem: Codable {
    let foodClass: String               // Class of the food
    let description: String             // Description of the food item
    let foodNutrients: [FoodNutrient]   // List of nutrients in the food item
}

// Struct to represent a collection of foundation foods with Codable conformance for easy encoding and decoding
struct FoundationFoods: Codable {
    let foundationFoods: [FoodItem]     // List of food items
}
