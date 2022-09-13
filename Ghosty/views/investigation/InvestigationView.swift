//
//  InvestigationView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct InvestigationView: View {
    
    @ObservedObject var model = InvestigationViewModel()
    
    @State var orientation = UIDevice.current.orientation
    
    @State var ghosts : [Ghost]
    @State var evidences : [String]
    
    @State var currentEvidence : [String] = []
    
    @State var remainingGhosts : [Ghost]
    
    @State var disabled = false
    
    init(ghosts: [Ghost], evidences: [String]){
        self.ghosts = ghosts
        self.evidences = evidences
        remainingGhosts = ghosts
        for evidence in evidences {
            model.addEvidence(evidence: evidence)
        }
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Section("Evidence Gathered"){
                    List{
                        ForEach (evidences, id: \.self) {evidence in
                            Toggle(evidence,
                                   isOn: model.checkedBinding(for: evidence)
                            ).disabled(model.evidencesDisabled[evidence]!)
                        }
                    }
                    .onChange(of: model, perform: { newValue in
                        updateView()
                    })
                    Button("Clear Evidence", action: {
                        model.clearEvidence()
                    })
                    .padding()
                }
                
                Section("Remaining ghosts"){
                    List {
                        ForEach(remainingGhosts, id:\.name) { ghost in
                            NavigationLink {
                                GhostDetailView(ghost: ghost)
                            } label: {
                                VStack {
                                    HStack {
                                        Text(ghost.name).font(.headline)
                                        Spacer()
                                    }
                                    HStack{
                                        ForEach(ghost.remainingEvidence(currentEvidence: currentEvidence).sorted {
                                            $0 < $1
                                        }, id: \.self) { e in
                                            Text(e).font(.caption).italic()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
            }.navigationTitle("Investigation")
        }
    }
    
    
    private func updateView(){
        remainingGhosts = []
        var foundEvidence : [String] = []
        for(key, value) in model.evidencesChecked {
            if(value) {
                foundEvidence.append(key)
            }
        }
        currentEvidence = foundEvidence
        var possibleEvidence : Set<String> = []
        
        for ghost in ghosts {
            if(ghost.isValid(currentEvidence: foundEvidence)){
                remainingGhosts.append(ghost)
                for evidence in ghost.evidence {
                    possibleEvidence.insert(evidence)
                }
            }
        }
        for (key, _) in model.evidencesDisabled {
            if(!possibleEvidence.contains(key)){
                model.evidencesDisabled[key] = true
            }
        }
    }
    
}

struct InvestigationView_Previews: PreviewProvider {
    static var previews: some View {
        InvestigationView(ghosts: [Ghost(id: 1, evidence: ["Finger prints"], name: "Ben", description: "Spooky ghost")], evidences: ["Finger Prints", "EMF Level 5", "Freezing Temperatures", "Spirit Box", "Ghost Writing"])
            .previewInterfaceOrientation(.portrait)
    }
}


public class InvestigationViewModel: ObservableObject, Equatable {
    
    @Published var evidencesChecked : [String:Bool] = [:]
    @Published var evidencesDisabled : [String:Bool] = [:]
    
    func addEvidence(evidence: String){
        evidencesChecked[evidence] = false
        evidencesDisabled[evidence] = false
    }
    
    func clearEvidence(){
        for(key, _) in evidencesChecked {
            evidencesChecked[key] = false
            evidencesDisabled[key] = false
        }
    }
    
    func checkedBinding(for key: String) -> Binding<Bool> {
        return Binding(get: {
            return self.evidencesChecked[key] ?? false
        }, set: {
            self.evidencesChecked[key] = $0
        })
    }
    
    func disabledBinding(for key: String) -> Binding<Bool> {
        return Binding(get: {
            return self.evidencesDisabled[key] ?? false
        }, set: {
            self.evidencesDisabled[key] = $0
        })
    }
    
    public static func == (lhs: InvestigationViewModel, rhs: InvestigationViewModel) -> Bool {
        for (key, value) in lhs.evidencesChecked {
            if(value != rhs.evidencesChecked[key]){
                return true
            }
        }
        return false
    }
}
