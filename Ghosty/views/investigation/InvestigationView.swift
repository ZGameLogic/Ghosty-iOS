//
//  InvestigationView.swift
//  Ghosty
//
//  Created by Benjamin Shabowski on 9/11/22.
//

import SwiftUI

struct InvestigationView: View {
    
    let PURPLE_COLOR = Color(red: 160 / 255.0, green: 64 / 255.0, blue: 201 / 255.0)
    
    @ObservedObject var model = InvestigationViewModel()
    
    @State var orientation = UIDevice.current.orientation
    
    @State var ghosts : [Ghost] = []
    @State var evidences : [String] = []
    
    @State var currentEvidence : [String] = []
    
    @State var remainingGhosts : [Ghost] = []
    
    @State var disabled = false
    
    @State var isLoadingGhosts = true
    @State var isLoadingEvidence = true
    @State var showError = false
    
    var body: some View {
        NavigationView {
            if(isLoadingGhosts || isLoadingEvidence){
                ProgressView()
            } else {
                VStack {
                    Section(header: Text("Evidence").font(.title)){
                        List{
                            ForEach (evidences.sorted(by: {$0 < $1}), id: \.self) {evidence in
                                Toggle(evidence,
                                       isOn: model.checkedBinding(for: evidence)
                                ).disabled(model.evidencesDisabled[evidence] ?? false)
                                    .tint(PURPLE_COLOR)
                                    .minimumScaleFactor(0.20)
                            }
                        }.border(.gray)
                            .onChange(of: model, perform: { newValue in
                                updateView()
                            })
                        Button("Clear Evidence", action: {
                            model.clearEvidence()
                        })
                        .padding([.bottom, .top], 10)
                        .padding([.leading, .trailing], 20)
                        .background(PURPLE_COLOR)
                        .foregroundColor(.white)
                        .clipShape(Rectangle())
                        .cornerRadius(20.0)
                    }
                    
                    Divider()
                        .overlay(.gray)
                    Section(header: Text("Ghosts").font(.title)){
                        List {
                            ForEach(remainingGhosts.sorted {
                                $0.name < $1.name
                            }, id:\.name) { ghost in
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
                                                Text(e)
                                                    .font(.caption)
                                                    .italic()
                                            }
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }.border(.gray)
                        Spacer()
                    }
                    
                }.navigationTitle("Investigation")
                    .alert("Unable to connect to GhostyAPI",
                           isPresented: $showError,
                           actions: {
                        Button("Okay", action: {})
                        Button("Try again", action: {
                            showError = false
                            loadData()
                        })
                    },
                           message: {
                        Text("Make sure you are connected to the internet")
                    })
            }
        }.onAppear(perform: {
            if(isLoadingGhosts && isLoadingEvidence){
                loadData()
            }
        })
    }
    
    private func loadData(){
        isLoadingGhosts = true
        isLoadingEvidence = true
        loadGhosts()
        loadEvidence()
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
            } else {
                model.evidencesDisabled[key] = false
            }
        }
    }
    
    private func loadEvidence(){
        guard let url = URL(string: "\(Constants.URL)/Evidence") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Evidences.self, from: data) {
                            DispatchQueue.main.async {
                                self.evidences = response.evidence
                                isLoadingEvidence = false
                                for evidence in evidences {
                                    model.addEvidence(evidence: evidence)
                                }
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
    
    private func loadGhosts(){
        guard let url = URL(string: "https://zgamelogic.com/ghosty/Ghosts2") else {
                  return
              }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data {
                        if let response = try? JSONDecoder().decode(Ghosts.self, from: data) {
                            DispatchQueue.main.async {
                                self.ghosts = response.ghosts
                                remainingGhosts = ghosts
                                isLoadingGhosts = false
                            }
                            return
                        }
                    } else {
                        showError = true
                    }
                }.resume()
    }
    
}

struct InvestigationView_Previews: PreviewProvider {
    static var previews: some View {
        InvestigationView(ghosts: [Ghost(id: 1, evidence: ["Finger prints"], name: "Ben", description: "Spooky ghost")], evidences: ["Finger Prints", "EMF Level 5", "Freezing Temperatures", "Spirit Box", "Ghost Writing"], remainingGhosts: [])
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
