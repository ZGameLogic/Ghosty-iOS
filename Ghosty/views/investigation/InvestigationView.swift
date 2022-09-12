//
//  InvestigationView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct InvestigationView: View {
    
    @State var orientation = UIDevice.current.orientation
    
    @State var ghosts : [Ghost]
    @State var evidences : [String]
    
    @State var currentEvidence : [String] = []
    
    @State var remainingGhosts : [Ghost]
    
    //"Ghost Orbs","Fingerprints","Freezing Temperatures","D.O.T.S. Projector","Spirit Box","Ghost Writing","EMF Level 5"
    @State var ghostOrbChecked = false
    @State var fingerPrintChecked = false
    @State var freezingTempChecked = false
    @State var dotsChecked = false
    @State var spiritBoxChecked = false
    @State var ghostWritingChecked = false
    @State var emfChecked = false
    
    @State var disabled = false
    
    init(ghosts: [Ghost], evidences: [String]){
        self.ghosts = ghosts
        self.evidences = evidences
        remainingGhosts = ghosts
    }
    
    var body: some View {
        NavigationView{
            VStack {
                Section("Evidence Gathered"){
                    List{
                        Toggle("D.O.T.S. Projector", isOn: $dotsChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("EMF Level 5", isOn: $emfChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("Fingerprints", isOn: $fingerPrintChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("Freezing Temperatures", isOn: $freezingTempChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("Ghost Orbs", isOn: $ghostOrbChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("Ghost Writing", isOn: $ghostWritingChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                        Toggle("Spirit Box", isOn: $spiritBoxChecked)
                            .padding([.leading, .trailing], 15)
                            .disabled(disabled)
                    }
                    .onChange(of: dotsChecked, perform: {old in updateView()})
                    .onChange(of: emfChecked, perform: {old in updateView()})
                    .onChange(of: fingerPrintChecked, perform: {old in updateView()})
                    .onChange(of: freezingTempChecked, perform: {old in updateView()})
                    .onChange(of: ghostOrbChecked, perform: {old in updateView()})
                    .onChange(of: ghostWritingChecked, perform: {old in updateView()})
                    .onChange(of: spiritBoxChecked, perform: {old in updateView()})
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
        if(dotsChecked) {foundEvidence.append("D.O.T.S. Projector")}
        if(emfChecked) {foundEvidence.append("EMF Level 5")}
        if(fingerPrintChecked) {foundEvidence.append("Fingerprints")}
        if(freezingTempChecked) {foundEvidence.append("Freezing Temperatures")}
        if(ghostOrbChecked) {foundEvidence.append("Ghost Orbs")}
        if(ghostWritingChecked) {foundEvidence.append("Ghost Writing")}
        if(spiritBoxChecked) {foundEvidence.append("Spirit Box")}
        
        currentEvidence = foundEvidence
        
        for ghost in ghosts {
            if(ghost.isValid(currentEvidence: foundEvidence)){
                remainingGhosts.append(ghost)
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
