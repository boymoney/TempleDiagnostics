import SwiftUI

// Struct to represent a UIViewController in SwiftUI
struct CameraView: UIViewControllerRepresentable {
    // Environment variable to manage presentation mode
    @Environment(\.presentationMode) var presentationMode
    // Binding to the selected diet type
    @Binding var selectedDiet: DietType

    // Function to create and configure the UIViewController
    func makeUIViewController(context: Context) -> CameraController {
        // Initialize the CameraController
        let cameraController = CameraController()
        // Set the selected diet type in the CameraController
        cameraController.selectedDiet = selectedDiet
        return cameraController // Return the configured CameraController
    }

    // Function to update the UIViewController when the SwiftUI state changes
    func updateUIViewController(_ uiViewController: CameraController, context: Context) {
        // Update the selected diet type in the CameraController
        uiViewController.selectedDiet = selectedDiet
    }
}
