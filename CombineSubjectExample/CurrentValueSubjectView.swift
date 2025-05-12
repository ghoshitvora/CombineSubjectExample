//
//  CurrentValueSubjectView.swift
//  CombineSubjectExample
//
//  Created by Ghoshit.
//

import SwiftUI
import Combine

class EmailViewModel: ObservableObject {
    let emailSubject = CurrentValueSubject<String, Never>("")
    
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

struct CurrentValueSubjectView: View {
    @StateObject private var viewModel = EmailViewModel()
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
            .navigationTitle("CurrentValueSubject")
        }
}
/**
 🧪 Explanation
 emailSubject holds the current state of the input.

 As soon as a subscriber connects, it receives the latest email string.

 Validation logic runs continuously and updates the UI live.

 This is perfect for form fields where you always need to track the latest input.
 
 **/

#Preview {
    CurrentValueSubjectView()
}
