//
//  TaskClassifier.swift
//  ADHD Support
//
//  Created by Peter McMichael on 1/20/26.
//

import Foundation
import CoreML

final class TaskClassifier {
    static let shared = TaskClassifier()
    
    private let model: To_do_list?
    
    private init() {
        model = try? To_do_list(configuration: MLModelConfiguration())
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
            let confidence = result.bestConfidence()
            
            
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

private extension To_do_listOutput {
    func bestConfidence() -> Double {
        let mirror = Mirror(reflecting: self)
        
        if let probs = mirror.children.compactMap({ $0.value as? [String: Double]}).first {
            return probs[label] ?? 0.0
        }
        return 0.0
    }
}
