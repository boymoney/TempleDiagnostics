import UIKit
import SwiftUI

// Custom view for displaying text labels and recommendation views over the camera feed
class CameraOverlayView: UIView {
    // Arrays to hold UILabels and recommendation UIViews
    private var textLabels: [UILabel] = []
    private var recommendationViews: [UIView] = []

    
    
    
    // Function to update the overlay with recognized texts and their corresponding recommendations
    func updateOverlay(with texts: [String], recommendations: [MenuItemRecommendation]) {
        // Remove all previous labels and views from the superview
        textLabels.forEach { $0.removeFromSuperview() }
        recommendationViews.forEach { $0.removeFromSuperview() }
        textLabels.removeAll() // Clear the textLabels array
        recommendationViews.removeAll() // Clear the recommendationViews array

        // Loop through the texts and their corresponding recommendations
        for (index, text) in texts.enumerated() {
            // Create and configure a UILabel for each recognized text
            let label = UILabel()
            label.text = text
            label.textColor = .white // Set text color to white
            label.backgroundColor = .black.withAlphaComponent(0.7) // Set background color to semi-transparent black
            label.font = UIFont.boldSystemFont(ofSize: 16) // Set font to bold system font, size 16
            label.sizeToFit() // Resize the label to fit the text
            label.frame.origin = CGPoint(x: 20, y: 40 + index * 40) // Position the label
            self.addSubview(label) // Add the label to the view
            textLabels.append(label) // Add the label to the textLabels array

            // Create a UIView for each recommendation based on its score
            let recommendationView = UIView()
            switch recommendations[index].score {
            case .good:
                recommendationView.backgroundColor = .green // Green for good recommendations
            case .neutral:
                recommendationView.backgroundColor = .yellow // Yellow for neutral recommendations
            case .bad:
                recommendationView.backgroundColor = .red // Red for bad recommendations
            }
            // Position and size the recommendation view next to the label
            recommendationView.frame = CGRect(x: 20 + label.frame.width + 10, y: label.frame.origin.y, width: 20, height: 20)
            self.addSubview(recommendationView) // Add the recommendation view to the view
            recommendationViews.append(recommendationView) // Add the view to the recommendationViews array
        }
    }
}
