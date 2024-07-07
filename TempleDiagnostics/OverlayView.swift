import SwiftUI

// View to display overlay text with a background color based on diet recommendation
struct OverlayView: View {
    let text: String // Text to be displayed in the overlay
    let dietRecommendation: RecommendationScore // Diet recommendation score for the overlay
    
    var body: some View {
        // Display the text with padding, background color, corner radius, and styling
        Text(text)
            .padding() // Add padding around the text
            .background(colorForRecommendation(dietRecommendation)) // Set background color based on recommendation score
            .cornerRadius(8) // Round the corners of the background
            .foregroundColor(.white) // Set the text color to white
            .font(.headline) // Set the font to headline style
    }
    
    
    
    
    // Function to return a color based on the recommendation score
    func colorForRecommendation(_ recommendation: RecommendationScore) -> Color {
        switch recommendation {
        case .bad:
            return Color.red // Red color for bad recommendations
        case .neutral:
            return Color.yellow // Yellow color for neutral recommendations
        case .good:
            return Color.green // Green color for good recommendations
        }
    }
}

// Preview provider for OverlayView to display a sample view in the Xcode canvas
struct OverlayView_Previews: PreviewProvider {
    static var previews: some View {
        OverlayView(text: "Sample Text", dietRecommendation: .good) // Sample overlay with text and a good recommendation
    }
}
