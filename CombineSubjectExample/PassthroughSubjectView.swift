//
//  PassthroughSubjectView.swift
//  CombineSubjectExample
//
//  Created by Ghoshit.
//

import SwiftUI
import Combine

class EventViewModel: ObservableObject {
    let emailSubject = PassthroughSubject<String, Never>()
    
    @Published var isValidEmail = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        emailSubject
            .map { $0.contains("@") && $0.contains(".") }
            .receive(on: RunLoop.main)
            .assign(to: &$isValidEmail)
    }
    
    func updateEmail(_ email: String) {
        emailSubject.send(email)
    }
}
struct PassthroughSubjectView: View {
    @StateObject private var viewModel = EventViewModel()
    @State private var emailInput = ""
    
    var body: some View {
        VStack(spacing: 16) {
            TextField("Enter Email", text: $emailInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onChange(of: emailInput) { newValue in
                    viewModel.updateEmail(newValue)
                }
            
            Text(viewModel.isValidEmail ? "✅ Valid Email" : "❌ Invalid Email")
                .foregroundColor(viewModel.isValidEmail ? .green : .red)
        }
        .padding()
        .navigationTitle("PassthroughSubject")
    }
}

#Preview {
    PassthroughSubjectView()
}

/**
 🧪 Explanation
 
 PassthroughSubject only delivers data when send() is called.

 If a new subscriber is added after a value is sent, it will not receive the previous value.

 Best used for discrete actions where old values are irrelevant.
 
 */
