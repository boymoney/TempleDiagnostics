import UIKit

// Manager class to handle the overlay updates on a view
class OverlayManager {

    // Function to overlay text on the view
    func overlayText(recognizedTextsAndBoxes: [(text: String, boundingBox: CGRect)], pixelBuffer: CVPixelBuffer, view: UIView) {
        let imageWidth = CGFloat(CVPixelBufferGetWidth(pixelBuffer))
        let imageHeight = CGFloat(CVPixelBufferGetHeight(pixelBuffer))
        let screenSize = UIScreen.main.bounds.size
        let scaleX = (screenSize.width / imageWidth)
        let scaleY = (screenSize.height / imageHeight)

        for recognizedTextAndBox in recognizedTextsAndBoxes {
            //if recognizedTextAndBox.text == "Fresh Lemonade"{
                let boundingBox = recognizedTextAndBox.boundingBox

                            // Convert the normalized coordinates to image coordinates
                           

                            // Create the CGRect for the screen coordinates
                let screenRect = CGRect(x: (boundingBox.origin.x * imageWidth) * scaleX, y: (boundingBox.origin.y * imageHeight) * scaleY, width: 100, height: 30)

                            // Create a UILabel for the overlay
                            let label = UILabel(frame: screenRect)
                            label.text = recognizedTextAndBox.text
                            label.textColor = UIColor.green
                            label.backgroundColor = UIColor.clear
                            label.textAlignment = .center
                            label.font = UIFont.boldSystemFont(ofSize: 14)

                            // Add the label to the view
                            view.addSubview(label)
            //}
            
        }

    }

    // Function to update the overlay on a given view with recognized texts and their corresponding recommendations
    func updateOverlay(on view: UIView, with texts: [(text: String, boundingBox: CGRect)], recommendations: [MenuItemRecommendation], pixelBuffer: CVPixelBuffer) {
        // Clear previous labels and views from the view
        view.subviews.forEach { $0.removeFromSuperview() }

        // Overlay the text with green labels
        overlayText(recognizedTextsAndBoxes: texts, pixelBuffer: pixelBuffer, view: view)

        // Print a message indicating the overlay has been updated, for debugging purposes
        print("Overlay updated with texts: \(texts) and recommendations: \(recommendations.map { $0.score })")
    }
}
