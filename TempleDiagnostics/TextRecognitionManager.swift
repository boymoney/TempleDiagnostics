import Foundation
import Vision

// Manager for handling text recognition and processing
class TextRecognitionManager {
    var fileManagerHelper: FileManagerHelper // Helper for file management tasks
    var dietRecommendationManager: DietRecommendationManager // Manager for diet recommendations
    
    // Initializer for the TextRecognitionManager
    init(dietRecommendationManager: DietRecommendationManager, fileManagerHelper: FileManagerHelper) {
        self.dietRecommendationManager = dietRecommendationManager
        self.fileManagerHelper = fileManagerHelper
    }
    
    // Function to recognize text from a pixel buffer
    func recognizeText(from pixelBuffer: CVPixelBuffer, completion: @escaping ([(String,  CGRect)], CVPixelBuffer) -> Void) {
        // Create a request handler for the image buffer
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        // Create a text recognition request
        let request = VNRecognizeTextRequest { (request, error) in
            // Extract recognized text observations
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion([], pixelBuffer)
                return
            }
            
           
                
            
            // Extract recognized texts from the observations
            //let recognizedTexts = observations.compactMap { $0.topCandidates(1).first?.string }
            let recognizedTextsAndBoxes: [(text: String, boundingBox: CGRect)] = observations.compactMap { observation in
                        guard let topCandidate = observation.topCandidates(1).first else {
                            return nil
                        }
                        return (text: topCandidate.string, boundingBox: observation.boundingBox)
                    }
            completion(recognizedTextsAndBoxes, pixelBuffer)
        }
        
        do {
            // Perform the text recognition request
            try requestHandler.perform([request])
        } catch {
            print("Error performing text recognition: \(error)")
            completion([], pixelBuffer)
        }
    }
    
    // Function to process recognized texts and generate menu item recommendations
    func processRecognizedText(_ texts: [(String,  CGRect)], completion: @escaping ([MenuItemRecommendation]) -> Void) {
        // Read FDA data from the specified file
        guard let fdaData = fileManagerHelper.readFDAData(from: "FoundationalFoodData") else {
            completion([])
            return
        }
        
        let stringsArray: [String] = texts.map { $0.0 }
        // Analyze the menu items using the diet recommendation manager
        let recommendations = dietRecommendationManager.analyzeMenuItems(stringsArray, nutritionalData: fdaData)
        completion(recommendations)
    }
}
