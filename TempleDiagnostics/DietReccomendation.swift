import Foundation

// Manager class for diet recommendations
class DietRecommendationManager {
    var selectedDiet: DietType // The selected diet type
    
    // Initializer for the DietRecommendationManager
    init(selectedDiet: DietType) {
        self.selectedDiet = selectedDiet
    }
    
    // Function to analyze menu items based on nutritional data
    func analyzeMenuItems(_ menuItems: [String], nutritionalData: [String: Any]) -> [MenuItemRecommendation] {
        var recommendations: [MenuItemRecommendation] = [] // Array to store recommendations
        
        // Iterate through each menu item
        for item in menuItems {
            // Get nutritional information for the menu item
            if let nutritionInfo = nutritionalData[item] as? [String: Any] {
                // Evaluate the item based on the selected diet
                let score = evaluateItemForDiet(nutritionInfo)
                // Create a recommendation for the item
                let recommendation = MenuItemRecommendation(itemName: item, score: score)
                // Add the recommendation to the array
                recommendations.append(recommendation)
            }
        }
        
        return recommendations // Return the array of recommendations
    }
    
    // Private function to evaluate a menu item based on its nutritional information and the selected diet
    private func evaluateItemForDiet(_ nutritionInfo: [String: Any]) -> RecommendationScore {
        // Extract nutritional values from the nutrition info dictionary
        let protein = nutritionInfo["protein"] as? Int ?? 0
        let carbs = nutritionInfo["carbs"] as? Int ?? 0
        let fats = nutritionInfo["fats"] as? Int ?? 0
        
        // Determine the recommendation score based on the selected diet
        switch selectedDiet {
        case .keto:
            // For keto diet, good score if carbs are less than 20 and fats are greater than 50
            return (carbs < 20 && fats > 50) ? RecommendationScore.good : RecommendationScore.bad
        case .vegan:
            // For vegan diet, good score if protein is greater than 10 and fats are less than 20
            return (protein > 10 && fats < 20) ? RecommendationScore.good : RecommendationScore.bad
        default:
            // Neutral score for other diets
            return .neutral
        }
    }
}

// Enumeration to represent different diet types
enum DietType: String, CaseIterable, Identifiable {
    case keto, vegan, vegetarian, carnivore, atkins, weightWatchers, lowCarb, paleo, mediterranean, dash, pescatarian, flexitarian, whole30, rawVegan, zone
    
    var id: String { self.rawValue } // Identifier for each diet type
}

// Enumeration to represent recommendation scores
enum RecommendationScore {
    case good, neutral, bad
}

// Struct to represent a recommendation for a menu item
struct MenuItemRecommendation {
    let itemName: String // The name of the menu item
    let score: RecommendationScore // The recommendation score for the item
}
