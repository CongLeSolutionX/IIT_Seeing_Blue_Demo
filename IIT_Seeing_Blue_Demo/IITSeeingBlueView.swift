//
//MIT License
//
//Copyright © 2025 Cong Le
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
//
//
//  IITSeeingBlueView.swift
//  IIT_Seeing_Blue_Demo
//
//  Created by Cong Le on 6/30/25.
//


import SwiftUI
import Combine

// MARK: - Introduction and Citations
/*
 * This SwiftUI view provides a conceptual implementation of the Information Integration Theory (IIT)
 * of consciousness, focusing on the "Seeing Blue" thought experiment described by Giulio Tononi.
 * The code models the distinction between processes that are part of the main conscious experience
 * (the "Main Complex" with high Φ) and those that are informationally insulated yet causally linked.
 *
 * The core objective is to illustrate how, according to IIT, the quality of an experience (e.g., "blue")
 * is not merely the activity of "blue neurons" but is defined by the state of the entire complex,
 * which differentiates that specific experience from a vast repertoire of all other possible experiences.
 *
 * Key Citations:
 * 1. Tononi, Giulio. 2004. “An Information Integration Theory of Consciousness.”
 *    BMC Neuroscience 5 (1): 42. https://doi.org/10.1186/1471-2202-5-42.
 *
 * 2. Tononi, Giulio, and Olaf Sporns. 2003. “Measuring Information Integration.”
 *    BMC Neuroscience 4 (1): 31. https://doi.org/10.1186/1471-2202-4-31.
 */

// MARK: - 1. Model Layer: Defining the Neural Components

/// A protocol representing any neural process, conscious or unconscious.
protocol NeuralProcess {
    var name: String { get }
    var description: String { get }
    var isActive: Bool { get set }
}

/// A protocol for neural systems that are informationally insulated from the main complex.
/// According to IIT, these systems do not directly contribute to the *quality* or *quantity* of
/// conscious experience, even if they are causally necessary for its initiation or behavioral output.
/// (Tononi 2004, "Neural activity in sensory afferents... does not contribute directly to it").
protocol InformationallyInsulated: NeuralProcess { }

// --- Concrete Implementations of Insulated Systems ---

/// Models the retina, which transduces light but is not part of the conscious percept.
struct Retina: InformationallyInsulated {
    var name = "👁️ Retina"
    var description = "Transduces photons into neural signals. Acts as a 'port-in' to the main complex."
    var isActive = false
}

/// Models afferent pathways that relay information.
struct AfferentPathways: InformationallyInsulated {
    var name = "→🧠 Afferent Pathways"
    var description = "Relays sensory information from the retina to the thalamocortical system."
    var isActive = false
}

/// Models motor pathways executing behavioral responses.
struct MotorPathways: InformationallyInsulated {
    var name = "🦾 Motor Pathways"
    var description = "Executes motor commands (e.g., button press). A 'port-out' from the main complex."
    var isActive = false
}

/// Models automated, unconscious processing loops.
/// (Tononi 2004, "...cortico-subcortico-cortical loops... do not contribute directly to conscious experience").
struct SubcorticalLoops: InformationallyInsulated {
    var name = "🔄 Subcortical Loops"
    var description = "Handles automated tasks like subvocalization. Informationally insulated."
    var isActive = false
}

/// Models the cerebellum's role in automated motor control.
/// Its modular structure results in low Φ, precluding it from contributing to unified consciousness.
/// (Tononi 2004, "Other brain regions with comparable numbers of neurons, such as the cerebellum, do not contribute...").
struct Cerebellum: InformationallyInsulated {
    var name = "🧠 Cerebellum"
    var description = "Manages automated functions like posture and gaze. Highly modular, low Φ."
    var isActive = true // Always active in the background
}


/// A protocol for an element within a conscious complex. Its state contributes to the overall experience.
protocol ComplexElement: NeuralProcess, Identifiable {
    var id: String { get }
}

/// Models a group of neurons within the main complex, selective for a specific quale (e.g., a color).
struct ConsciousNeuronalGroup: ComplexElement {
    let id: String
    var name: String
    var description: String
    var isActive = false
}

/// The Main Complex: The substrate of consciousness.
/// A system is a complex if it has a capacity to integrate information (Φ > 0)
/// and is not part of a larger system with higher Φ.
/// (Tononi and Sporns 2003, "Measuring information integration").
struct MainComplex: NeuralProcess {
    var name = "🌟 Main Complex"
    var description = "The integrated thalamocortical network where information is unified to form a single conscious experience."
    var isActive = true
    
    /// The elements that constitute the complex. The state of ALL elements defines the experience.
    var elements: [ConsciousNeuronalGroup]
    
    /// A simplified, conceptual calculation of Φ (Phi).
    /// Real Φ calculation is computationally intensive. This models the core idea:
    /// Φ depends on the number of elements and their interconnectivity. It quantifies the irreducibility of the system.
    /// IIT posits that consciousness *is* integrated information, so Φ measures the quantity of consciousness.
    var phi: Double {
        // A conceptual formula: Φ grows with the number of elements (differentiation)
        // and an interconnection factor (integration). `log2` reflects the information-theoretic basis.
        let differentiation = Double(elements.count)
        guard differentiation > 1 else { return 0.0 }
        
        let interconnectionFactor = 1.0 // Assume maximal integration for this model
        
        // This calculates the information in bits from the number of possible states (2^n)
        let informationCapacity = log2(pow(2.0, differentiation))
        
        return interconnectionFactor * informationCapacity
    }
    
    /// Determines the specific quality of the current conscious experience.
    /// IIT's crucial claim: The experience is the entire state of the complex, specifying one
    /// point in a vast "qualia space" and ruling out all others.
    /// (Tononi 2004, "...it is the activity state of *all* elements of the complex that defines a given conscious state...").
    func specifyExperience() -> String {
        let activeElements = elements.filter { $0.isActive }
        
        if activeElements.isEmpty {
            return "An experience of 'nothingness' or pure awareness, defined by the potential for all other states."
        }
        
        let activeNames = activeElements.map { "'\($0.name.replacing(" Neurons", with: ""))'" }.joined(separator: ", ")
        let inactiveCount = elements.count - activeElements.count
        
        return "A unified experience of \(activeNames). This specific quality is defined by its differentiation from the \(inactiveCount) other potential states within the complex (e.g., 'red', 'sound', etc.), creating a unique point in qualia space."
    }
}


// MARK: - 2. ViewModel Layer: Managing the Simulation State

class ConsciousnessViewModel: ObservableObject {
    
    // --- Processes OUTSIDE the main experience ---
    @Published var retina = Retina()
    @Published var afferentPathways = AfferentPathways()
    @Published var motorPathways = MotorPathways()
    @Published var subcorticalLoops = SubcorticalLoops()
    @Published var cerebellum = Cerebellum()
    
    // --- The Main Conscious Complex ---
    @Published var mainComplex: MainComplex
    
    @Published var resultingExperience: String = "System is idle."
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Initialize the Main Complex with a repertoire of potential experiences.
        self.mainComplex = MainComplex(elements: [
            ConsciousNeuronalGroup(id: "blue", name: "Blue Neurons", description: "Selective for the color blue."),
            ConsciousNeuronalGroup(id: "red", name: "Red Neurons", description: "Selective for the color red."),
            ConsciousNeuronalGroup(id: "shape", name: "Shape Neurons", description: "Selective for geometric shapes."),
            ConsciousNeuronalGroup(id: "sound", name: "Sound Neurons", description: "Selective for auditory tones."),
            ConsciousNeuronalGroup(id: "thought", name: "Thought Neurons", description: "Represents an abstract thought.")
        ])
    }
    
    /// Simulates the entire process of perceiving a blue light.
    func presentBlueLight() {
        // Reset the state before starting the simulation
        resetSystemState()
        
        // Use DispatchQueue to simulate the temporal flow of neural events.
        let queue = DispatchQueue.main
        
        queue.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.retina.isActive = true
        }
        
        queue.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.afferentPathways.isActive = true
        }
        
        queue.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            // The signal reaches the main complex and activates the relevant neurons.
            guard let self = self else { return }
            if let blueIndex = self.mainComplex.elements.firstIndex(where: { $0.id == "blue" }) {
                self.mainComplex.elements[blueIndex].isActive = true
                
                // The conscious experience is generated HERE from the state of the complex.
                self.resultingExperience = self.mainComplex.specifyExperience()
            }
        }
        
        queue.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            // Signals are sent to other insulated systems for behavioral output and unconscious processing.
            self?.motorPathways.isActive = true
            self?.subcorticalLoops.isActive = true
        }
    }
    
    /// Resets all components to their default state.
    func resetSystemState() {
        retina.isActive = false
        afferentPathways.isActive = false
        motorPathways.isActive = false
        subcorticalLoops.isActive = false
        
        for i in 0..<mainComplex.elements.count {
            mainComplex.elements[i].isActive = false
        }
        
        resultingExperience = "System is idle."
    }
}


// MARK: - 3. View Layer: UI for Visualization

public struct SeeingBlueView: View {
    
    @StateObject private var viewModel = ConsciousnessViewModel()
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
                // --- Header and Controls ---
                VStack {
                    Text("IIT: \"Seeing Blue\" Simulation")
                        .font(.largeTitle).bold()
                        .multilineTextAlignment(.center)
                    Text("A conceptual model of the Information Integration Theory of Consciousness.")
                        .font(.footnote)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                }
                
                HStack(spacing: 20) {
                    Button(action: viewModel.presentBlueLight) {
                        Label("Present Blue Light", systemImage: "lightbulb.fill")
                            .font(.headline)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.blue)
                    
                    Button(action: viewModel.resetSystemState) {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                    }
                    .buttonStyle(.bordered)
                }
                
                // --- Main Complex Visualization ---
                MainComplexView(mainComplex: $viewModel.mainComplex)
                
                // --- Resulting Experience ---
                VStack(alignment: .leading, spacing: 10) {
                    Text("Resulting Conscious Experience")
                        .font(.headline)
                    Text(viewModel.resultingExperience)
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                }
                
                // --- Insulated Processes Visualization ---
                InsulatedProcessesView(
                    retina: $viewModel.retina,
                    afferentPathways: $viewModel.afferentPathways,
                    motorPathways: $viewModel.motorPathways,
                    subcorticalLoops: $viewModel.subcorticalLoops,
                    cerebellum: $viewModel.cerebellum
                )
                
            }
            .padding()
        }
    }
}


// MARK: - Reusable Subviews

/// A view that displays the status of a single neural process.
struct NeuralProcessView: View {
    @Binding var process: NeuralProcess
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Circle()
                    .fill(process.isActive ? .green : .gray)
                    .frame(width: 10, height: 10)
                Text(process.name)
                    .font(.headline)
                Spacer()
                Text(process.isActive ? "Active" : "Inactive")
                    .font(.caption.bold())
                    .foregroundColor(process.isActive ? .green : .gray)
            }
            Text(process.description)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

/// A specialized view for rendering the Main Complex and its elements.
struct MainComplexView: View {
    @Binding var mainComplex: MainComplex
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(mainComplex.name)
                .font(.title2).bold()
            Text(mainComplex.description)
                .font(.subheadline).foregroundColor(.secondary)
            
            HStack {
                Text("Integrated Information (Φ):")
                    .font(.headline)
                Text(String(format: "%.2f bits", mainComplex.phi))
                    .font(.system(.headline, design: .monospaced))
                    .foregroundColor(.purple)
            }
            
            Text("Complex Elements:")
                .font(.headline)
                .padding(.top, 5)

            // Display each element of the complex
            ForEach($mainComplex.elements) { $element in
                HStack {
                    Circle()
                        .fill(element.isActive ? .cyan : .gray.opacity(0.5))
                        .frame(width: 8, height: 8)
                    Text(element.name)
                    Spacer()
                    Text(element.isActive ? "Firing" : "Quiescent")
                        .font(.caption)
                        .foregroundColor(element.isActive ? .cyan : .secondary)
                }
                .padding(.leading)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.1))
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.yellow.opacity(0.5), lineWidth: 2)
        )
    }
}

/// A view that groups and displays all the informationally insulated systems.
struct InsulatedProcessesView: View {
    @Binding var retina: Retina
    @Binding var afferentPathways: AfferentPathways
    @Binding var motorPathways: MotorPathways
    @Binding var subcorticalLoops: SubcorticalLoops
    @Binding var cerebellum: Cerebellum
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Informationally Insulated Processes (Outside the Experience)")
                .font(.title2).bold()
                .padding(.bottom, 5)
            
            NeuralProcessView(process: .init(get: { retina }, set: { retina = $0 as! Retina }))
            NeuralProcessView(process: .init(get: { afferentPathways }, set: { afferentPathways = $0 as! AfferentPathways }))
            NeuralProcessView(process: .init(get: { motorPathways }, set: { motorPathways = $0 as! MotorPathways }))
            NeuralProcessView(process: .init(get: { subcorticalLoops }, set: { subcorticalLoops = $0 as! SubcorticalLoops }))
            NeuralProcessView(process: .init(get: { cerebellum }, set: { cerebellum = $0 as! Cerebellum }))
        }
    }
}


// MARK: - SwiftUI Preview
struct SeeingBlueView_Previews: PreviewProvider {
    static var previews: some View {
        SeeingBlueView()
    }
}
