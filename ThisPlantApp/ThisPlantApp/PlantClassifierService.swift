import SwiftUI
import Vision
import CoreML

typealias Prediction = (name: String, confidence: String, place: Int)

class PlantClassifierService: ObservableObject {
    @Published var selectedImage: UIImage? = nil
    @Published var predictionsTop3: [Prediction] = []
    @Published var isLoading: Bool = false

    private let initialModel = try? PlantClassifier(configuration: MLModelConfiguration())
    private var vnCoreMLModel: VNCoreMLModel?
    private var request: VNCoreMLRequest?

    init() {
        guard let initialModel = initialModel else { return }
        vnCoreMLModel = try? VNCoreMLModel(for: initialModel.model)
        request = VNCoreMLRequest(model: vnCoreMLModel!, completionHandler: response)
    }

    func tryImage() {
        guard let image = selectedImage else { return }
        isLoading = true

        let handler = VNImageRequestHandler(cgImage: image.cgImage!)
        try? handler.perform([request!])
    }

    func response(request: VNRequest, error: Error?) {
        guard error == nil else {
            print("Error")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("Error")
            return
        }
        
        let elementsTop3 = observations.sorted(by: { $0.confidence > $1.confidence }).prefix(3)
        
        var predictions: [Prediction] = []
        for i in 0..<3 {
            let element = elementsTop3[i]
            predictions.append((String(element.identifier.split(separator: "(").first ?? "unknown"), element.confidence.formatted(.percent.precision(.fractionLength(0))), i))
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.predictionsTop3 = predictions
            self?.isLoading = false
        }
    }
}
