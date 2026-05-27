//
//  PrioritiesClassifier.swift
//  ADHD Support
//
//  Created by Peter McMichael on 2/5/26.
//



//  TaskClassifier.swift
//  ADHD Support
//
//  Created by Peter McMichael on 1/20/26.
//

import Foundation
import CoreML

final class PrioritiesClassifier {
    static let shared = PrioritiesClassifier()
    
    private let model: Priorities?
    
    private init() {
        model = try? Priorities(configuration: MLModelConfiguration())
    }
    
    struct Prediction {
        let label: String
        let confidence: Double
        
        static let unknown = Prediction(label: "Unknown", confidence: 0.0)
        static let error = Prediction(label: "Error", confidence: 0.0)
    }
    
    func predictPriority(for text: String) -> Prediction {
        guard let model else { return.unknown }
        
        let trimmed = text.trimmed
        
        guard !trimmed.isEmpty else { return .unknown}
        
        do {
            let result = try model.prediction(text: trimmed)
            let confidence = result.bestConfidence(for: result.label)
            
            
            return Prediction(label: normalizedPriorityLabel(result.label), confidence: confidence)
            
        } catch {
            return .error
        }
    }
    
    private func normalizedPriorityLabel(_ label: String) -> String {
        switch label.trimmed.lowercased() {
            case "low":
                return "low"
            case "high":
                return "high"
        case "urgent":
            return "urgent"
        default:
            return "medium"
            
        }
    }
}


private extension String {
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private extension PrioritiesOutput {
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
