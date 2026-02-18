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
            let confidence = result.bestConfidence()
            
            
            return Prediction(label: result.label.lowercased(), confidence: confidence)
            
            
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

private extension PrioritiesOutput {
    func bestConfidence() -> Double {
        let mirror = Mirror(reflecting: self)
        
        if let probs = mirror.children.compactMap({ $0.value as? [String: Double]}).first {
            return probs[label] ?? 0.0
        }
        return 0.0
    }
}
