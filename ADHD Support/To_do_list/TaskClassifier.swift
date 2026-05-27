import Foundation
import CoreML

final class TaskClassifier {
    static let shared = TaskClassifier()
    
    //name of model
    private let model: Todo_list?
    
    private init() {
        model = try? Todo_list(configuration: MLModelConfiguration())
    }
    
    struct Prediction {
        let label: String
        let confidence: Double
        
        static let unknown = Prediction(label: "Unknown", confidence: 0.0)
        static let error = Prediction(label: "Error", confidence: 0.0)
    }
    
    func predictCategory(for text: String) -> Prediction {
        guard let model else { return.unknown }
        
        let trimmed = text.trimmed
        
        guard !trimmed.isEmpty else { return .unknown}
        
        do {
            let result = try model.prediction(text: trimmed)
            let confidence = result.bestConfidence(for: result.label)
            
            
            return Prediction(label: result.label, confidence: confidence)
            
            
        } catch {
            return .error
        }
    }
}


private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension MLFeatureProvider {
    func bestConfidence(for label: String) -> Double {
        for name in featureNames {
            guard let feature = featureValue(for: name), feature.type == .dictionary else { continue }

            if let confidence = feature.dictionaryValue.first(where: { entry in
                String(describing: entry.key).caseInsensitiveCompare(label) == .orderedSame
            })?.value {
                return confidence.doubleValue
            }
        }

        return 0.0
    }
}
