import UIKit
import AVFoundation
import Vision
import NaturalLanguage

class CameraController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var trackedTextObservations = [VNDetectedObjectObservation]()
    var boundingBoxViews = [String: UIView]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCamera()
        setupVision()
    }

    func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high

        guard let camera = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: camera) else { return }
        captureSession.addInput(input)

        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
    }

    func setupVision() {
        textRecognitionRequest = VNRecognizeTextRequest { [weak self] (request, error) in
            guard let results = request.results as? [VNRecognizedTextObservation] else { return }
            self?.handleTextRecognitionResults(results)
        }
        textRecognitionRequest.recognitionLevel = .accurate
    }

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let requestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])

        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Failed to perform request: \(error)")
        }
    }

    func handleTextRecognitionResults(_ results: [VNRecognizedTextObservation]) {
        DispatchQueue.main.async { [weak self] in
            let filteredResults = self?.filterMenuItems(from: results) ?? []
            self?.updateBoundingBoxes(for: filteredResults)
        }
    }

    func filterMenuItems(from observations: [VNRecognizedTextObservation]) -> [VNRecognizedTextObservation] {
        var filteredObservations = [VNRecognizedTextObservation]()
        
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            let recognizedText = topCandidate.string
            if isMenuItem(text: recognizedText) {
                filteredObservations.append(observation)
            }
        }
        
        return filteredObservations
    }

    func isMenuItem(text: String) -> Bool {
        let tagger = NLTagger(tagSchemes: [.lexicalClass, .nameTypeOrLexicalClass])
        tagger.string = text
        
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        var isMenuItem = false
        
        // Check if the text contains any digits, which would likely be a price or a number
        if text.rangeOfCharacter(from: .decimalDigits) != nil {
            return false
        }
        
        // Enumerate lexical classes and check if it contains nouns or other relevant words
        tagger.enumerateTags(in: text.startIndex..<text.endIndex, unit: .word, scheme: .lexicalClass, options: options) { tag, tokenRange in
            if let tag = tag, tag == .noun || tag == .otherWord {
                isMenuItem = true
                return false // Stop enumerating
            }
            return true // Continue enumerating
        }
        
        return isMenuItem
    }

    func updateBoundingBoxes(for observations: [VNRecognizedTextObservation]) {
        // Remove all bounding box views that are not in the new observations
        for (text, boundingBoxView) in boundingBoxViews {
            if !observations.contains(where: { $0.topCandidates(1).first?.string == text }) {
                boundingBoxView.removeFromSuperview()
                boundingBoxViews.removeValue(forKey: text)
            }
        }

        // Update or add new bounding box views
        for observation in observations {
            guard let topCandidate = observation.topCandidates(1).first else { continue }
            let recognizedText = topCandidate.string

            let boundingBox = observation.boundingBox
            let convertedRect = previewLayer.layerRectConverted(fromMetadataOutputRect: boundingBox)

            if let boundingBoxView = boundingBoxViews[recognizedText] {
                boundingBoxView.frame = convertedRect
            } else {
                let newBoundingBoxView = UIView(frame: convertedRect)
                newBoundingBoxView.layer.borderColor = UIColor.red.cgColor
                newBoundingBoxView.layer.borderWidth = 2
                view.addSubview(newBoundingBoxView)
                boundingBoxViews[recognizedText] = newBoundingBoxView
            }
        }
    }
}
