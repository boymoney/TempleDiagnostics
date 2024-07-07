import Foundation

// Helper class for managing file-related tasks
class FileManagerHelper {
    // Function to read FDA data from a JSON file
    func readFDAData(from fileName: String) -> [String: Any]? {
        // Get the URL of the file from the main bundle
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("FDA data file not found") // Print error message if file is not found
            return nil // Return nil if the file is not found
        }
        
        do {
            // Read data from the file URL
            let data = try Data(contentsOf: url)
            // Deserialize the JSON data into a dictionary
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            //print("FDA data: \(json)") // Print the FDA data for testing
            return json as? [String: Any] // Return the JSON data as a dictionary
        } catch {
            // Print error message if there is an issue reading or deserializing the data
            print("Error reading FDA data: \(error)")
            return nil // Return nil if there is an error
        }
    }
}
