import SwiftUI
import CoreML
struct MLTestView: View {
    @State private var input: String = ""
    @State private var predictedLabel: String = "—"
    @State private var topProbabilities: [(String, Double)] = []
    
    private let model: Todo_list?
    private let modelInitError: Error?
    
    init() {
        var builtModel: Todo_list?
        var initError: Error?
        do {
            let configuration = MLModelConfiguration()
            builtModel = try Todo_list(configuration: configuration)
        } catch {
            initError = error
            builtModel = nil
        }
        self.model = builtModel
        self.modelInitError = initError
    }
    
    var body: some View {
        Form {
            Section("Input") {
                TextField("Type a task…", text: $input)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
            }
            
            Section("Prediction") {
                if let error = modelInitError {
                    Text("Model failed to load: \(error.localizedDescription)")
                        .foregroundStyle(.red)
                } else if model == nil {
                    Text("Model unavailable.")
                        .foregroundStyle(.red)
                } else {
                    Text("Label: \(predictedLabel)")
                    ForEach(topProbabilities, id: \.0) { label, prob in
                        Text("\(label): \(Int(prob * 100))%")
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("ML Test")
        .onChange(of: input) { _, newValue in
            predict(newValue)
        }
        .onAppear {
            predict(input)
        }
    }
    
    private func predict(_ text: String) {
        guard let model else {
            predictedLabel = "—"
            topProbabilities = []
            return
        }
        
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            predictedLabel = "—"
            topProbabilities = []
            return
        }
        
        do {
            let result = try model.prediction(text: trimmed)
            predictedLabel = result.label
            
            // Find the first output property that is a [String: Double]
            let mirror = Mirror(reflecting: result)
            if let probs = mirror.children.compactMap({ $0.value as? [String: Double] }).first {
                topProbabilities = probs
                    .sorted { $0.value > $1.value }
                    .prefix(5)
                    .map { ($0.key, $0.value) }
            } else {
                topProbabilities = []
            }
            
        } catch {
            predictedLabel = "Error"
            topProbabilities = []
            print("ML prediction error: \(error)")
        }
    }
}




