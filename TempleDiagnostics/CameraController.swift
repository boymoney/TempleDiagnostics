import UIKit
import AVFoundation

// Main view controller for handling camera functionality and text recognition
class CameraController: UIViewController {
    var overlayView: CameraOverlayView! // Overlay view to display recommendations
    var textRecognitionManager: TextRecognitionManager! // Manager for text recognition
    var overlayManager: OverlayManager! // Manager for overlay updates
    var selectedDiet: DietType = .keto // Default diet type
    
    private var captureSession: AVCaptureSession! // Session to coordinate the flow of data from the camera
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer! // Layer to display the camera input
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera() // Setup the camera
        
        // Initialize and add the overlay view
        overlayView = CameraOverlayView(frame: self.view.frame)
        self.view.addSubview(overlayView)
        
        // Initialize managers
        let dietRecommendationManager = DietRecommendationManager(selectedDiet: selectedDiet)
        let fileManagerHelper = FileManagerHelper()
        textRecognitionManager = TextRecognitionManager(dietRecommendationManager: dietRecommendationManager, fileManagerHelper: fileManagerHelper)
        overlayManager = OverlayManager()
    }
    
    // Function to setup the camera
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high // Set the session preset to high quality
        
        // Ensure the back camera is available
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("Unable to access back camera!")
            return
        }
        
        do {
            // Add the back camera as an input to the capture session
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
            
            // Setup output to capture video frames
            let output = AVCaptureVideoDataOutput()
            output.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
            captureSession.addOutput(output)
            
            // Setup the preview layer to display the camera input
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer.videoGravity = .resizeAspectFill
            videoPreviewLayer.frame = view.layer.bounds
            view.layer.insertSublayer(videoPreviewLayer, at: 0)
            
            // Start running the capture session
            captureSession.startRunning()
        } catch {
            print("Error setting up the camera: \(error)")
        }
    }
    
    // Function to process recognized text
   
    func processRecognizedText(_ texts: [(String, CGRect)], pixelBuffer: CVPixelBuffer) {
        textRecognitionManager.processRecognizedText(texts) { [weak self] recommendations in
            // Update the overlay with recognized texts, recommendations, and possibly using the pixelBuffer on the main thread
            DispatchQueue.main.async {
                self?.overlayManager.updateOverlay(on: self?.overlayView ?? UIView(), with: texts, recommendations: recommendations, pixelBuffer: pixelBuffer)
            }
        }
    }

}

// Extension to handle video output and text recognition
extension CameraController: AVCaptureVideoDataOutputSampleBufferDelegate {
    // Delegate method called when a new video frame is available
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // Extract the image buffer from the sample buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        // Recognize text from the image buffer
        textRecognitionManager.recognizeText(from: pixelBuffer) { [weak self] recognizedTexts, pixelBuffer in
            self?.processRecognizedText(recognizedTexts, pixelBuffer: pixelBuffer) // Process the recognized text
        }
    }
}
