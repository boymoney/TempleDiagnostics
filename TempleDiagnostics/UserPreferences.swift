import Foundation

// Struct to represent user preferences, conforming to Codable for easy encoding and decoding
struct UserPreferences: Codable {
    var preferredItems: [String] // List of preferred food items
    var restrictedItems: [String] // List of restricted food items
    
    // Static function to load the user's diet preferences from storage
    static func loadUserDiet() -> DietType {
        // Load the user's diet preferences from storage
        // This is a placeholder implementation
        // TODO: Replace with actual loading logic
        return .keto // Default diet type to return
    }
}
