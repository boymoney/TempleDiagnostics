import SwiftUI

// View to display nutritional information from a JSON file
struct JSONTestView: View {
    // State variable to hold the list of food items
    @State private var nutritionalItems: [FoodItem] = []

    var body: some View {
        // List to display nutritional items
        List(nutritionalItems, id: \.description) { item in
            VStack(alignment: .leading) {
                // Display the description of the food item
                Text(item.description)
                    .font(.headline)
                // Loop through each nutrient in the food item and display its information
                ForEach(item.foodNutrients, id: \.id) { nutrient in
                    Text("\(nutrient.nutrient.name): \(nutrient.amount ?? 0) \(nutrient.nutrient.unitName)")
                        .font(.subheadline)
                }
            }
        }
        // Load nutritional data when the view appears
        .onAppear(perform: loadNutritionalData)
    }

    // Function to load nutritional data from a JSON file
    func loadNutritionalData() {
        // Get the URL of the JSON file from the main bundle
        if let url = Bundle.main.url(forResource: "FoundationalFoodData", withExtension: "json") {
            do {
                // Read the data from the JSON file
                let jsonData = try Data(contentsOf: url)
                // Parse the nutritional data and assign it to the state variable
                if let foodItems = parseNutritionalData(from: jsonData) {
                    self.nutritionalItems = foodItems
                }
            } catch {
                // Print error message if there is an issue reading the JSON file
                print("Error reading JSON file: \(error)")
            }
        } else {
            // Print error message if the JSON file is not found
            print("JSON file not found")
        }
    }

    // Function to parse nutritional data from JSON data
    func parseNutritionalData(from data: Data) -> [FoodItem]? {
        let decoder = JSONDecoder()
        do {
            // Decode the JSON data into FoundationFoods struct
            let foundationFoods = try decoder.decode(FoundationFoods.self, from: data)
            // Return the list of food items
            return foundationFoods.foundationFoods
        } catch {
            // Print error message if there is an issue decoding the JSON data
            print("Error decoding JSON data: \(error)")
            return nil
        }
    }
}
