import Foundation
import CoreGraphics

protocol CameraControllerDelegate: AnyObject {
    func didRecognizeText(_ text: String, boundingBox: CGRect, score: Double)
    func didFailToRecognizeText(with error: Error)
}
